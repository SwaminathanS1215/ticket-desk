import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import isEqual from 'ticket-desk/helpers/is-equal';
import { STATUS_OPTIONS, PRIORITY_OPTIONS, SOURCE_OPTIONS } from '../constants.js';

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
    <div class="max-w-3xl p-8 bg-white shadow-lg rounded-xl">
      <h1 class="text-2xl font-semibold mb-6 text-gray-800">
        {{#if @isEdit}}
          Update #{{@formData.ticket_id}}
        {{else}}
          New Ticket
        {{/if}}
      </h1>

      <form {{on "submit" this.submit}} class="space-y-6">
        <div>
          <label class="font-medium">Requestor <span class="text-red-500">*</span></label>
          <input
            type="text"
            value={{this.form.requestor}}
            {{on "input" (fn this.updateField "requestor")}}
            class="w-full border px-3 py-2 rounded {{if this.errors.requestor 'border-red-500'}}"
          />

          {{#if this.errors.requestor}}
            <p class="text-xs text-red-600 mt-1">{{this.errors.requestor}}</p>
          {{/if}}
        </div>
        <div>
          <label class="font-medium">Title <span class="text-red-500">*</span></label>
          <input
            type="text"
            value={{this.form.title}}
            {{on "input" (fn this.updateField "title")}}
            class="w-full border px-3 py-2 rounded {{if this.errors.title 'border-red-500'}}"
          />
          {{#if this.errors.title}}
            <p class="text-xs text-red-600 mt-1">{{this.errors.title}}</p>
          {{/if}}
        </div>
        <div>
          <label class="font-medium">Description <span class="text-red-500">*</span></label>
          <textarea
            value={{this.form.description}}
            {{on "input" (fn this.updateField "description")}}
            class="w-full border px-3 py-2 rounded h-32
              {{if this.errors.description 'border-red-500'}}"
          ></textarea>
          {{#if this.errors.description}}
            <p class="text-xs text-red-600 mt-1">{{this.errors.description}}</p>
          {{/if}}
        </div>
        <div>
          <label class="font-medium">Status <span class="text-red-500">*</span></label>
          <select
            value={{this.form.status}}
            {{on "change" (fn this.updateField "status")}}
            class="w-full border px-3 py-2 rounded {{if this.errors.status 'border-red-500'}}"
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
          <label class="font-medium">Priority</label>
          <select
            value={{this.form.priority}}
            {{on "input" (fn this.updateField "priority")}}
            class="w-full border px-3 py-2 rounded"
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
          <label class="font-medium">Source</label>
          <select
            value={{this.form.source}}
            {{on "input" (fn this.updateField "source")}}
            class="w-full border px-3 py-2 rounded capitalize"
          >
            {{#each @formData.sourceOptions as |opt|}}
              <option value={{opt}} selected={{isEqual this.form.source opt}}>{{opt}}</option>
            {{/each}}
          </select>
        </div>
        <div>
          <label class="font-medium">Assign To</label>
          <select
            {{on "change" (fn this.updateField "assign_to")}}
            class="w-full border px-3 py-2 rounded"
          >
            <option value="">Select assignee</option>

            {{#each @formData.users as |user|}}
              <option value={{user.email}}>
                {{user.name}}
                ({{user.email}})
              </option>
            {{/each}}
          </select>
          {{#if this.errors.assign_to}}
            <p class="text-xs text-red-600 mt-1">{{this.errors.assign_to}}</p>
          {{/if}}
        </div>
        <button
          type="submit"
          class="w-full bg-indigo-600 hover:bg-indigo-700 text-white py-2 rounded"
        >
          {{if this.loading "Creating..." "Create Ticket"}}
        </button>
      </form>
    </div>
  </template>
}
