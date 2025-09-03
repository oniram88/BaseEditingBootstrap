// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as bootstrap from "bootstrap"
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import { Application } from '@hotwired/stimulus'
import RailsNestedForm from '@stimulus-components/rails-nested-form'

const application = Application.start()
application.register('nested-form', RailsNestedForm)