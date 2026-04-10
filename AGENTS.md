# AGENTS.md

This file provides context and instructions for AI coding agents working on the **BaseEditingBootstrap** project.

## Project Overview
BaseEditingBootstrap is a Rails engine designed to provide a standardized, Bootstrap-based administrative interface for Rails models. It integrates with Pundit for authorization and Ransack for searching/sorting.

- **Main Components**:
    - `BaseEditingController`: The base controller for all CRUD operations.
    - `BaseModel`: A concern for models that should support standard editing.
    - `BaseModelPolicy`: A base Pundit policy with specific methods for controlling UI elements.

## Build & Test
The project uses Docker for environment setup and testing.

- **Setup Environment**:
    ```bash
    docker compose run app spec/dummy/bin/setup
    ```
- **Run Tests**:
    ```bash
    docker compose run app bundle exec rspec
    ```
- **Start Development Server**:
    ```bash
    docker compose up
    ```

## Development Workflow
- **Naming Conventions**: Follow standard Rails/Ruby naming conventions (snake_case for files and methods, CamelCase for classes).
- **Git Flow**: Use descriptive commit messages. No specific branching strategy is enforced, but use feature branches.
- **Testing**:
    - **Controllers**: Use `it_behaves_like "base editing controller"`.
    - **Models**: Use `it_behaves_like "a base model"`.
    - **Policies**: Use `it_behaves_like "a standard base model policy"`.
    - Ensure all new features or bug fixes include corresponding RSpec tests.

## Coding Conventions & Patterns
- **Pundit Policies**:
    - Implement `editable_attributes` to define fields visible/editable in forms.
    - Implement `search_result_fields` to define columns in the index table.
    - Implement `search_fields` for Ransack search form fields.
    - Implement `permitted_attributes` for Pundit strong parameters.
- **Factories**:
    - Every model factory should include a trait `:with_invalid_attributes` for testing validation failures.
- **Form/Cell Overrides**:
    - Use the provided generators for field/cell overrides:
        ```bash
        rails g base_editing_bootstrap:field_override ModelName field1 field2:type
        rails g base_editing_bootstrap:cell_override ModelName field1 field2:type
        ```
- **I18n**: Follow the project's translation structure for messages and labels (see `README.md`).

## Security
- Always use Pundit for authorization (`include Pundit::Authorization` in `ApplicationController`).
- Ensure `permitted_attributes` in policies correctly restrict user input.
