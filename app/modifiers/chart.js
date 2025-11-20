import Modifier from 'ember-modifier';
import Chart from 'chart.js/auto';
import { callback } from 'chart.js/helpers';

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
            borderWidth: 0,
            spacing: 2,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '70%',
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              padding: 15,
              usePointStyle: true,
              pointStyle: 'circle',
              font: {
                size: 12,
              },
            },
          },
        },
        tooltip: {
          callbacks: {
            label: function (context) {
              return context.label + ': ' + context.parsed;
            },
          },
        },
      },
    });
  }
}
