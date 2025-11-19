import Component from '@glimmer/component';
import { service } from '@ember/service';
import { LinkTo } from '@ember/routing';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { HomeIcon, TicketIcon, ChevronIcon } from '../utils/icons';

export default class LayoutSidebar extends Component {
  @service sidebar;

  HomeIcon = HomeIcon;
  TicketIcon = TicketIcon;

  <template>
    <aside
      class="fixed top-16 left-0 bottom-0 bg-indigo-900 text-indigo-100 border-r border-indigo-800 shadow-xl overflow-y-auto transition-all duration-300 ease-in-out"
      style={{this.sidebar.sidebarStyle}}
    >
      <nav class="mt-4">
        <ul class="space-y-2">

          <li>
            <LinkTo
              @route="dashboard"
              class="flex items-center gap-3 px-5 py-2 rounded-lg hover:bg-indigo-700 font-medium transition"
            >
              {{this.HomeIcon}}
              {{#unless this.sidebar.collapsed}}
                Dashboard
              {{/unless}}
            </LinkTo>
          </li>

          <li>
            <LinkTo
              @route="ticket"
              class="flex items-center gap-3 px-5 py-2 rounded-lg hover:bg-indigo-700 font-medium transition"
            >
              {{this.TicketIcon}}
              {{#unless this.sidebar.collapsed}}
                Ticket List
              {{/unless}}
            </LinkTo>
          </li>

        </ul>
      </nav>
    </aside>
  </template>
}
