import Component from '@glimmer/component';

export default class DashboardLayout extends Component {
  <template>
    <div class="p-6 space-y-6">
      {{yield}}
    </div>
  </template>
}
