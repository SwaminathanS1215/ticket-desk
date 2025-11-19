import Component from '@glimmer/component';
import Checkbox from 'ticket-desk/components/ui/checkbox.gjs'; // <-- ADD THIS

export default class TicketTable extends Component {
  get headers() {
    return this.args.tableHeader ?? [];
  }

  get rows() {
    return this.args.tableData ?? [];
  }

  <template>
    <div
      class="overflow-x-auto rounded-lg border border-gray-200 shadow-sm bg-white"
    >
      <table class="min-w-full text-left border-collapse">
        <thead class="bg-gray-100 border-b border-gray-200">
          <tr>
            {{#each this.headers as |col|}}
              <th
                class="px-4 py-3 text-sm font-semibold text-gray-700 whitespace-nowrap"
              >
                {{col.title}}
              </th>
            {{/each}}
          </tr>
        </thead>

        <tbody>
          {{#each this.rows as |ticket|}}
            <tr
              class="odd:bg-white even:bg-gray-50 hover:bg-gray-100 transition"
            >
              {{#each this.headers as |col|}}
                <td
                  class="px-4 py-3 text-sm text-gray-900 border-b border-gray-200 whitespace-nowrap"
                >
                  {{#if col.isCheckbox}}
                    <Checkbox />
                  {{else}}
                    {{col.render ticket}}
                  {{/if}}
                </td>
              {{/each}}
            </tr>
          {{/each}}
        </tbody>
      </table>
    </div>
  </template>
}
