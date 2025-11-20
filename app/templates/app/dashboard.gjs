import MetricsPanel from '../../components/metrics-panel.gjs';
import ChartsPanel from '../../components/charts-panel.gjs';
import Component from '@glimmer/component';

export default class DashboardTemplate extends Component {
  <template>
    <MetricsPanel @metrics={{@model.metrics}} />
    <ChartsPanel @charts={{@model.charts}} />
  </template>
}
