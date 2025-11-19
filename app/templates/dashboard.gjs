import MetricsPanel from '../components/metrics-panel.gjs';
import ChartsPanel from '../components/charts-panel.gjs';
import Component from '@glimmer/component';
import DashboardLayout from '../components/dashboard-layout.gjs';

export default class DashboardTemplate extends Component {
  <template>
    <DashboardLayout>
      <MetricsPanel @metrics={{@model.metrics}} />
      <ChartsPanel @charts={{@model.charts}} />
    </DashboardLayout>
  </template>
}
