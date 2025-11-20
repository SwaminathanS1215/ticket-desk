import Modifier from 'ember-modifier';
import Chart from 'chart.js/auto';

export default class BarChartModifier extends Modifier {
  chartInstance = null;

  modify(element, [chartData]) {
    if (this.chartInstance) {
      this.chartInstance.destroy();
    }

    const ctx = element.getContext('2d');

    // Create gradient for bars
    const createGradient = () => {
      const gradient = ctx.createLinearGradient(0, 0, 400, 0);
      gradient.addColorStop(0, '#ec4899');
      gradient.addColorStop(0.5, '#a855f7');
      gradient.addColorStop(1, '#8b5cf6');
      return gradient;
    };

    this.chartInstance = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: chartData.data.map((d) => d.label),
        datasets: [
          {
            data: chartData.data.map((d) => d.value),
            backgroundColor: createGradient(),
            borderRadius: 20,
            barThickness: 8,
            categoryPercentage: 0.45,
            barPercentage: 0.6,
          },
        ],
      },
      options: {
        indexAxis: 'y',
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false,
          },
          tooltip: {
            enabled: true,
            displayColors: false,
            callbacks: {
              label: (ctx) => `${ctx.parsed.x} tickets`,
            },
          },
        },
        scales: {
          x: {
            beginAtZero: true,
            grid: {
              color: '#e5e7eb',
              drawBorder: false,
            },
            ticks: {
              color: '#6b7280',
              font: { size: 11 },
              stepSize: 1,
            },
          },
          y: {
            grid: { display: false },
            ticks: {
              color: '#374151',
              font: { size: 13, weight: 500 },
              padding: 10,
            },
          },
        },
        layout: {
          padding: {
            right: 25,
          },
        },
      },
      plugins: [
        {
          id: 'valueLabels',
          afterDatasetsDraw(chart) {
            const { ctx, data } = chart;

            chart.getDatasetMeta(0).data.forEach((bar, index) => {
              const value = data.datasets[0].data[index];

              ctx.save();
              ctx.fillStyle = '#374151';
              ctx.font = '600 13px system-ui';
              ctx.textAlign = 'left';

              ctx.fillText(value, bar.x + 10, bar.y + 5);
              ctx.restore();
            });
          },
        },
      ],
    });
  }
}
