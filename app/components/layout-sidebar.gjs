import Component from '@glimmer/component';
import { service } from '@ember/service';
import { LinkTo } from '@ember/routing';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { HomeIcon, TicketIcon, ChevronIcon } from '../utils/icons';
import { tracked } from '@glimmer/tracking';
import eq from 'ticket-desk/helpers/is-equal';
import { fn } from '@ember/helper';

export default class LayoutSidebar extends Component {
  @service sidebar;

  @tracked active = 'dashboard';

  HomeIcon = HomeIcon;
  TicketIcon = TicketIcon;
  AtomIcon = AtomIcon;
  ArrowIcon = ArrowIcon;

  @action toggleSidebar() {
    this.sidebar.toggle();
  }

  @action setActive(route) {
    this.active = route;
  }

  <template>
    <div
      class="relative h-full transition-all duration-300 ease-in-out"
      style={{this.sidebar.sidebarStyle}}
    >

      <aside
        class="fixed top-0 left-0 bottom-0 bg-global-blue w-full text-indigo-100 border-r border-indigo-800 shadow-xl transition-all duration-300 ease-in-out"
        style={{this.sidebar.sidebarStyle}}
      >

        <div class="flex items-center justify-start gap-5 px-6 py-6 mt-6 mb-8">
          {{this.AtomIcon}}

          {{#unless this.sidebar.collapsed}}
            <p class="font-medium">Ticket Desk</p>
          {{/unless}}

        </div>

        <button
          class="absolute top-20 bg-white rounded-full cursor-pointer p-1.5 transition-all duration-200 group hover:bg-indigo-700 shadow-lg
            {{if this.sidebar.collapsed 'left-14' '-right-2'}}"
          {{on "click" this.toggleSidebar}}
        >
          <!-- Inner wrapper -->
          <span
            class="flex items-center overflow-hidden transition-all duration-200
              {{if this.sidebar.collapsed 'w-3 group-hover:w-5' 'w-3 group-hover:w-5'}}"
          >
            <!-- Icon -->
            <span
              class="flex items-center text-black text-md transition-transform duration-200"
              class={{if
                this.sidebar.collapsed
                "transition-all group-hover:translate-x-[10px] rotate-0"
                "translate-x-[0px] rotate-180 "
              }}
            >
              {{this.ArrowIcon}}
            </span>
          </span>

          <!-- Tooltip -->
          <span
            class="absolute left-full top-1/2 -translate-y-1/2 ml-2 bg-black text-white text-xs px-2 py-1 rounded whitespace-nowrap pointer-events-none opacity-0 group-hover:opacity-100 transition-opacity duration-200"
          >
            {{#if this.sidebar.collapsed}}
              Expand
            {{else}}
              collapse
            {{/if}}
          </span>
        </button>

        <nav class="mt-4">
          <ul class="space-y-2 px-2">

            <li>
              <LinkTo
                @route="app.dashboard"
                @activeClass="bg-white text-gray-1002"
                class="flex items-center gap-4 px-5 py-2 rounded-md hover:bg-gray-1002 transition hover:text-white"
              >
                {{this.HomeIcon}}
                {{#unless this.sidebar.collapsed}}
                  Dashboard
                {{/unless}}
              </LinkTo>
            </li>

            <li>
              <LinkTo
                @route="app.ticket"
                @activeClass="bg-white text-gray-1002"
                class="flex items-center gap-4 px-5 py-2 rounded-md hover:bg-gray-1002 transition hover:text-white"
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
    </div>
  </template>
}
