// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as bootstrap from "bootstrap"
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import { Application } from '@hotwired/stimulus'

const application = Application.start()

import NestedForm from 'nested_form_controller'
application.register('nested-form', NestedForm)

