import Component from '@glimmer/component';
import { action } from '@ember/object';
import { scheduleOnce } from '@ember/runloop';
import Chart from 'chart.js/auto';

export default class ChartCardComponent extends Component {
  chartInstance = null;

  constructor() {
    super(...arguments);
    scheduleOnce('afterRender', this, this.drawChart);
  }

  drawChart() {
    const canvas = document.querySelector('#myPieChart');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');

    if (this.chartInstance) {
      this.chartInstance.destroy();
    }

    this.chartInstance = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: this.args.data.data.map((d) => d.label),
        datasets: [
          {
            data: this.args.data.data.map((d) => d.value),
            backgroundColor: this.args.data.data.map((d) => d.color),
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false, 
        plugins: {
          legend: {
            position: 'bottom',
          },
        },
      },
    });
  }

  <template>
    <div class="chart-container">
      <canvas id="myPieChart"></canvas>
    </div>
  </template>
}
