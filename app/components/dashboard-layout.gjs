import Component from '@glimmer/component';
import LayoutHeader from './layout-header.gjs';
import LayoutSidebar from './layout-sidebar.gjs';

export default class DashboardLayout extends Component {
  <template>
    <LayoutHeader />
    <LayoutSidebar />

    <main
      class="pt-20 ml-64 p-6 min-h-screen bg-gray-100 overflow-y-auto"
    >
      {{yield}}
    </main>
  </template>
}
