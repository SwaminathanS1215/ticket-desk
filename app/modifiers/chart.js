import Modifier from 'ember-modifier';
import Chart from 'chart.js/auto';

export default class ChartModifier extends Modifier {
  chartInstance = null;

  modify(element, [chartData]) {
    if (this.chartInstance) {
      this.chartInstance.destroy();
    }

    const ctx = element.getContext('2d');

    this.chartInstance = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: chartData.data.map((d) => d.label),
        datasets: [
          {
            data: chartData.data.map((d) => d.value),
            backgroundColor: chartData.data.map((d) => d.color),
          }
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: "60%",
        plugins: {
          legend: { position: "bottom" }
        }
      }
    });
  }
}
