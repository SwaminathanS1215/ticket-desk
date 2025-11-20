import Component from '@glimmer/component';
import LayoutHeader from './layout-header.gjs';
import LayoutSidebar from './layout-sidebar.gjs';
import { service } from '@ember/service';

export default class DashboardLayout extends Component {
  @service sidebar;

    get sidebarWidth() {
    return this.sidebar.collapsed ? "70px" : "260px";
  }

  <template>
    <div class="min-h-screen flex bg-gray-100">
      <LayoutSidebar @sidebar={{this.sidebar}}/>
      <div class="flex-1 flex flex-col">
        <LayoutHeader />
      <main
        class="pt-16 transition-all duration-300 ease-in-out"
        style="margin-left: {{this.sidebarWidth}}"
      >
        {{yield}}
      </main>
      </div>
    </div>
  </template>
}
