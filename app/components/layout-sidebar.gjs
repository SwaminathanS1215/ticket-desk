import Component from '@glimmer/component';
import { LinkTo } from '@ember/routing';

export default class LayoutSidebar extends Component {
  <template>
    <aside
      class="fixed top-16 left-0 bottom-0 w-64 bg-indigo-900 text-indigo-100 
             p-5 shadow-xl overflow-y-auto border-r border-indigo-800"
    >
      <nav>
        <ul class="space-y-3">

          <li>
            <LinkTo
              @route="index"
              class="block px-4 py-2 rounded-lg hover:bg-indigo-700 font-medium"
            >
              Dashboard
            </LinkTo>
          </li>
           <li>
            <LinkTo
              @route="ticket"
              class="block px-4 py-2 rounded-lg hover:bg-indigo-700 font-medium"
            >
              Ticket List
            </LinkTo>
          </li>
        </ul>
      </nav>
    </aside>
  </template>
}
