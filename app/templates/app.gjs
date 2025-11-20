import Component from '@glimmer/component';
import LayoutHeader from '../components/layout-header.gjs';
import LayoutSidebar from '../components/layout-sidebar.gjs';
import { service } from '@ember/service';

export default class AppTemplate extends Component {
  @service sidebar;

  get sidebarWidth() {
    return this.sidebar.collapsed ? '70px' : '260px';
  }

  get mainStyle() {
    return `
      margin-left: ${this.sidebarWidth};
      height: calc(100vh - 64px);
      width: calc(100vw - ${this.sidebarWidth});
      margin-top: 64px;
    `;
  }

  <template>
    <div class="min-h-screen w-full bg-gray-100 overflow-hidden flex">

      <LayoutSidebar />

      <div class="flex-1 flex flex-col overflow-hidden">

        <LayoutHeader />

        <main
          class="p-6 overflow-y-auto transition-all duration-300 ease-in-out"
          style={{this.mainStyle}}
        >
          {{outlet}}
        </main>

      </div>
    </div>
  </template>
}
