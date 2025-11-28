import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import isEqual from 'ticket-desk/helpers/is-equal';
import { STATUS_OPTIONS, PRIORITY_OPTIONS, SOURCE_OPTIONS } from '../constants.js';
import FileUploader from './ui/fileUpload.gjs';

export default class CreateTicketForm extends Component {
  @tracked form = { ...this.args.formData };

  @tracked errors = {
    requestor: '',
    title: '',
    description: '',
    status: '',
    assign_to: '',
  };

  @tracked loading = false;

  validate() {
    let newErrors = {
      requestor: '',
      title: '',
      description: '',
      status: '',
      assign_to: '',
    };

    let valid = true;

    if (!this.form.requestor?.trim()) {
      newErrors.requestor = 'Requestor is required';
      valid = false;
    }

    if (!this.form.title?.trim()) {
      newErrors.title = 'Title is required';

      valid = false;
    }

    if (!this.form.description?.trim()) {
      newErrors.description = 'Description is required';
      valid = false;
    }

    if (!this.form.status?.trim()) {
      newErrors.status = 'Status is required';
      valid = false;
    }
    this.errors = newErrors;

    return valid;
  }

  @action updateField(field, event) {
    this.form[field] = event.target.value;
    this.errors = { ...this.errors, [field]: '' };
  }

  // @action
  // handleFilesChange(files) {
  //   this.form = {
  //     ...this.form,
  //     attachments: files,
  //   };
  //   // You can perform additional operations here
  //   console.log('Updated files:', this.form, files);

  //   // Example: Extract actual File objects for upload
  //   const fileObjects = files.map((f) => f.file);
  //   console.log('File objects for upload:', fileObjects);
  // }

  @action async submit(e) {
    e.preventDefault();

    if (!this.validate()) {
      return;
    }

    this.loading = true;

    let payload = {
      ...this.form,
    };

    delete payload.statusOptions;
    delete payload.priorityOptions;
    delete payload.sourceOptions;

    try {
      await this.args.onSubmit(payload);
    } finally {
      this.loading = false;
    }
  }

  <template>
    <div class="relative w-full p-6 bg-white">
      <form {{on "submit" this.submit}} class="space-y-5">
        <div>
          <div class="flex items-center justify-between mb-2">
            <label class="text-sm font-normal text-gray-700">
              Requester
              <span class="text-red-500">*</span>
            </label>
            <button
              type="button"
              class="text-sm text-teal-600 hover:text-teal-700 flex items-center gap-1"
            >
              <span class="text-lg">⊕</span>
              Add new requester
            </button>
          </div>
          <input
            type="text"
            placeholder="Search"
            value={{this.form.requestor}}
            {{on "input" (fn this.updateField "requestor")}}
            class="w-full border border-gray-300 px-3 py-2 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent
              {{if this.errors.requestor 'border-red-500'}}"
          />
          {{#if this.errors.requestor}}
            <p class="text-xs text-red-600 mt-1">{{this.errors.requestor}}</p>
          {{/if}}
          <div class="mt-1 text-right">
            <button type="button" class="text-sm text-blue-600 hover:text-blue-700">Add Cc</button>
          </div>
        </div>

        <div>
          <label class="block text-sm font-normal text-gray-700 mb-2">
            Subject
            <span class="text-red-500">*</span>
          </label>
          <input
            type="text"
            value={{this.form.title}}
            {{on "input" (fn this.updateField "title")}}
            class="w-full border border-gray-300 px-3 py-2 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent
              {{if this.errors.title 'border-red-500'}}"
          />
          {{#if this.errors.title}}
            <p class="text-xs text-red-600 mt-1">{{this.errors.title}}</p>
          {{/if}}
        </div>

        <div>
          <label class="block text-sm font-normal text-gray-700 mb-2">Source</label>
          <select
            value={{this.form.source}}
            {{on "change" (fn this.updateField "source")}}
            class="w-full border border-gray-300 px-3 py-2 rounded bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent appearance-none"
            style="background-image: url('data:image/svg+xml;charset=UTF-8,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 24 24%27 fill=%27none%27 stroke=%27currentColor%27 stroke-width=%272%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27%3e%3cpolyline points=%276 9 12 15 18 9%27%3e%3c/polyline%3e%3c/svg%3e'); background-repeat: no-repeat; background-position: right 0.5rem center; background-size: 1.5em 1.5em; padding-right: 2.5rem;"
          >
            {{#each @formData.sourceOptions as |opt|}}
              <option value={{opt}} selected={{isEqual this.form.source opt}}>{{opt}}</option>
            {{/each}}
          </select>
        </div>

        <div>
          <label class="block text-sm font-normal text-gray-700 mb-2">
            Status
            <span class="text-red-500">*</span>
          </label>
          <select
            value={{this.form.status}}
            {{on "change" (fn this.updateField "status")}}
            class="w-full border border-gray-300 px-3 py-2 rounded bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent appearance-none
              {{if this.errors.status 'border-red-500'}}"
            style="background-image: url('data:image/svg+xml;charset=UTF-8,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 24 24%27 fill=%27none%27 stroke=%27currentColor%27 stroke-width=%272%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27%3e%3cpolyline points=%276 9 12 15 18 9%27%3e%3c/polyline%3e%3c/svg%3e'); background-repeat: no-repeat; background-position: right 0.5rem center; background-size: 1.5em 1.5em; padding-right: 2.5rem;"
          >
            <option value="">Select status</option>
            {{#each @formData.statusOptions as |s|}}
              <option
                selected={{isEqual this.form.status s.value}}
                value={{s.value}}
              >{{s.label}}</option>
            {{/each}}
          </select>
          {{#if this.errors.status}}
            <p class="text-xs text-red-600 mt-1">{{this.errors.status}}</p>
          {{/if}}
        </div>

        <div>
          <label class="block text-sm font-normal text-gray-700 mb-2">Urgency</label>
          <select
            value={{this.form.priority}}
            {{on "change" (fn this.updateField "priority")}}
            class="w-full border border-gray-300 px-3 py-2 rounded bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent appearance-none"
            style="background-image: url('data:image/svg+xml;charset=UTF-8,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 24 24%27 fill=%27none%27 stroke=%27currentColor%27 stroke-width=%272%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27%3e%3cpolyline points=%276 9 12 15 18 9%27%3e%3c/polyline%3e%3c/svg%3e'); background-repeat: no-repeat; background-position: right 0.5rem center; background-size: 1.5em 1.5em; padding-right: 2.5rem;"
          >
            {{#each @formData.priorityOptions as |s|}}
              <option
                value={{s.value}}
                selected={{isEqual this.form.priority s.value}}
              >{{s.label}}</option>
            {{/each}}
          </select>
        </div>

        <div>
          <label class="block text-sm font-normal text-gray-700 mb-2">Impact</label>
          <select
            value={{this.form.assign_to}}
            {{on "change" (fn this.updateField "assign_to")}}
            class="w-full border border-gray-300 px-3 py-2 rounded bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent appearance-none
              {{if this.errors.assign_to 'border-red-500'}}"
            style="background-image: url('data:image/svg+xml;charset=UTF-8,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 24 24%27 fill=%27none%27 stroke=%27currentColor%27 stroke-width=%272%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27%3e%3cpolyline points=%276 9 12 15 18 9%27%3e%3c/polyline%3e%3c/svg%3e'); background-repeat: no-repeat; background-position: right 0.5rem center; background-size: 1.5em 1.5em; padding-right: 2.5rem;"
          >
            <option value="">Select impact</option>
            <option value="low">Low</option>
            <option value="medium">Medium</option>
            <option value="high">High</option>
          </select>
          {{#if this.errors.assign_to}}
            <p class="text-xs text-red-600 mt-1">{{this.errors.assign_to}}</p>
          {{/if}}
        </div>

        <div>
          <label class="block text-sm font-normal text-gray-700 mb-2">Description</label>
          <textarea
            value={{this.form.description}}
            {{on "input" (fn this.updateField "description")}}
            class="w-full border border-gray-300 px-3 py-2 rounded h-32 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent
              {{if this.errors.description 'border-red-500'}}"
          ></textarea>
          {{#if this.errors.description}}
            <p class="text-xs text-red-600 mt-1">{{this.errors.description}}</p>
          {{/if}}
        </div>

        {{!-- <FileUploader @onFilesChange={{this.handleFilesChange}} @files={{this.form.attachments}} /> --}}

        <div class="flex justify-end gap-3 pt-4 bg-white w-full">
          <button
            type="button"
            class="px-6 py-2 border border-gray-300 rounded text-gray-700 hover:bg-gray-50 font-medium"
          >
            Cancel
          </button>
          <button
            type="submit"
            class="px-6 py-2 bg-blue-900 hover:bg-blue-800 text-white rounded font-medium flex items-center gap-2"
          >
            {{if this.loading "Submitting..." "Submit"}}
            {{#unless this.loading}}
              <span>▲</span>
            {{/unless}}
          </button>
        </div>
      </form>
    </div>
  </template>
}
