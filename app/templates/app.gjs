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
      margin-left: 16px;
      height: calc(100vh - 64px);
      flex:1;
    padding-top:80px
    `;
  }

  <template>
    <div class="min-h-screen w-full bg-white flex">

      <LayoutSidebar />

      <div class="flex-1 flex flex-col">

        <LayoutHeader />

        <main
          class="overflow-y-auto transition-all duration-300 ease-in-out bg-white"
          style={{this.mainStyle}}
        >
          {{outlet}}
        </main>

      </div>
    </div>
  </template>
}
