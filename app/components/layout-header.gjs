import Component from '@glimmer/component';

export default class LayoutHeader extends Component {
  <template>
    <header
      class="fixed top-0 left-0 right-0 h-16 bg-indigo-700 text-white flex items-center px-6 shadow-lg z-50 border-b border-indigo-600"
    >
      <h1 class="text-xl font-bold tracking-wide">Ticket Desk</h1>
    </header>
  </template>
}
