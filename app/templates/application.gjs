import Component from '@glimmer/component';
import DashboardLayout from '../components/dashboard-layout.gjs';

export default class ApplicationTemplate extends Component {
  <template>
    <DashboardLayout>
      {{outlet}}
    </DashboardLayout>
  </template>
}
