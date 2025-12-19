import Component from '@glimmer/component';
import { on } from '@ember/modifier';

export default class DeleteModal extends Component {
  <template>
    {{#if @isOpen}}
      <div class="fixed inset-0 z-50 flex items-center justify-center">
        {{! Backdrop }}
        <div class="absolute inset-0 bg-black opacity-50" {{on "click" @onCancel}}></div>

        {{! Modal }}
        <div class="relative bg-white rounded-lg shadow-xl max-w-md w-full mx-4 p-6">
          {{! Header }}
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-lg font-semibold text-gray-900">
              Confirm Delete
            </h3>
            <button
              type="button"
              class="text-gray-400 hover:text-gray-600"
              {{on "click" @onCancel}}
            >
              ✕
            </button>
          </div>

          {{! Content }}
          <div class="mb-6">
            <p class="text-gray-600">
              Are you sure you want to delete this ticket?
            </p>
            {{#if @ticketTitle}}
              <p class="mt-2 w-[250px] truncate text-sm font-medium text-gray-900">
                "{{@ticketTitle}}"
              </p>
            {{/if}}
            <p class="mt-2 text-sm text-red-600">
              This action cannot be undone.
            </p>
          </div>

          {{! Actions }}
          <div class="flex justify-end space-x-3">
            <button
              type="button"
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500"
              {{on "click" @onCancel}}
            >
              Cancel
            </button>
            <button
              type="button"
              class="px-4 py-2 text-sm font-medium text-white bg-red-600 border border-transparent rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
              {{on "click" @onConfirm}}
            >
              Delete
            </button>
          </div>
        </div>
      </div>
    {{/if}}
  </template>
}
