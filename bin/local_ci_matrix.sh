#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

COMPOSE=(docker compose --project-directory "$PROJECT_ROOT")
DRY_RUN=0
RUBY_FILTER=""
RAILS_FILTER=""
TEST_COMMAND="bundle exec rspec"
KEEP_DOCKER_CACHE=0

# Keep this matrix aligned with .github/workflows/ruby.yml.
RUBY_VERSIONS=(3.1 3.2 3.3 3.4 4.0)
RAILS_VERSIONS=(7.1 7.2 8.0 8.1)

# Combinations excluded in CI workflow.
declare -A EXCLUDED_TUPLES=(
  ["3.1|8.0"]=1
  ["3.1|8.1"]=1
)

cleanup_compose() {
  if [ "$DRY_RUN" -eq 1 ] || [ "$KEEP_DOCKER_CACHE" -eq 1 ]; then
    return 0
  fi

  "${COMPOSE[@]}" down --volumes --remove-orphans >/dev/null 2>&1 || true
}

compose_cmd() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '+'
    printf ' %q' "${COMPOSE[@]}" "$@"
    echo
    return 0
  fi

  "${COMPOSE[@]}" "$@"
}

version_selected() {
  local candidate="$1"
  local filter="$2"
  local value
  local -a values=()

  if [ -z "$filter" ]; then
    return 0
  fi

  IFS=',' read -r -a values <<<"$filter"
  for value in "${values[@]}"; do
    if [ "$candidate" = "$value" ]; then
      return 0
    fi
  done

  return 1
}

usage() {
  cat <<'EOF'
Uso: bin/local_ci_matrix.sh [opzioni]

Opzioni:
  --dry-run             Mostra i comandi docker compose senza eseguirli.
  --ruby 3.3,3.4        Esegue solo le versioni Ruby specificate (CSV).
  --rails 7.2,8.0       Esegue solo le versioni Rails specificate (CSV).
  --test-command CMD     Sostituisce il comando interno eseguito per i test.
  --keep-docker-cache    Disabilita la pulizia dei volumi Docker a fine run.
EOF
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --dry-run)
        DRY_RUN=1
        ;;
      --ruby)
        if [ "$#" -lt 2 ] || [[ "$2" == -* ]]; then
          echo "--ruby richiede una lista CSV di versioni" >&2
          exit 1
        fi
        RUBY_FILTER="${2:-}"
        shift
        ;;
      --rails)
        if [ "$#" -lt 2 ] || [[ "$2" == -* ]]; then
          echo "--rails richiede una lista CSV di versioni" >&2
          exit 1
        fi
        RAILS_FILTER="${2:-}"
        shift
        ;;
      --test-command)
        if [ "$#" -lt 2 ] || [[ "$2" == -* ]]; then
          echo "--test-command richiede un comando" >&2
          exit 1
        fi
        TEST_COMMAND="${2:-}"
        shift
        ;;
      --keep-docker-cache)
        KEEP_DOCKER_CACHE=1
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Opzione non riconosciuta: $1" >&2
        usage >&2
        exit 1
        ;;
    esac
    shift
  done
}

select_service() {
  local preferred_service="app"
  local selected_service=""
  local service
  local -a services=()

  mapfile -t services < <("${COMPOSE[@]}" config --services)

  if [ "${#services[@]}" -eq 0 ]; then
    echo "Nessun servizio trovato in docker-compose.yml" >&2
    return 1
  fi

  for service in "${services[@]}"; do
    if [ "$service" = "$preferred_service" ]; then
      selected_service="$preferred_service"
      break
    fi
  done

  if [ -z "$selected_service" ]; then
    selected_service="${services[0]}"
    echo "Servizio 'app' non trovato, uso '$selected_service'." >&2
  fi

  echo "$selected_service"
}

run_tuple() {
  local service="$1"
  local ruby_version="$2"
  local rails_version="$3"
  local step_status=0

  export CMPS_RUBY_VERSION="$ruby_version"
  export CMPS_RAILS_VERSION="$rails_version"

  echo
  echo "==> Ruby $ruby_version / Rails $rails_version"

  compose_cmd build "$service" || step_status=$?

  if [ "$step_status" -eq 0 ]; then
    compose_cmd run --rm --no-deps -e RAILS_ENV=test "$service" spec/dummy/bin/setup || step_status=$?
  fi

  if [ "$step_status" -eq 0 ]; then
    compose_cmd run --rm --no-deps -e RAILS_ENV=test "$service" bash -lc "$TEST_COMMAND" || step_status=$?
  fi

  cleanup_compose
  return "$step_status"
}

main() {
  local service
  local ruby_version
  local rails_version
  local tuple
  local -a failed_tuples=()

  parse_args "$@"

  trap cleanup_compose EXIT

  if [ "$DRY_RUN" -eq 1 ]; then
    service="app"
  else
    service="$(select_service)" || return 1
  fi

  for ruby_version in "${RUBY_VERSIONS[@]}"; do
    if ! version_selected "$ruby_version" "$RUBY_FILTER"; then
      continue
    fi

    for rails_version in "${RAILS_VERSIONS[@]}"; do
      if ! version_selected "$rails_version" "$RAILS_FILTER"; then
        continue
      fi

      tuple="$ruby_version|$rails_version"

      if [ -n "${EXCLUDED_TUPLES[$tuple]:-}" ]; then
        echo "-- SKIP $tuple (escluso nella matrix CI)"
        continue
      fi

      if ! run_tuple "$service" "$ruby_version" "$rails_version"; then
        failed_tuples+=("$tuple")
      fi
    done
  done

  if [ "${#failed_tuples[@]}" -gt 0 ]; then
    echo
    echo "Tuple fallite: ${failed_tuples[*]}" >&2
    return 1
  fi

  echo
  echo "Tutte le tuple sono state eseguite con successo."
}

main "$@"
