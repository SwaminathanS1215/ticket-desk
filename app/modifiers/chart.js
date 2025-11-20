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
            borderWidth: 0,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '65%',
        animation: {
          animateRotate: false,
          animateScale: false,
        },
        layout: {
          padding: {
            top: 50,
            bottom: 50,
            left: 100,
            right: 100,
          },
        },
        plugins: {
          legend: { display: false },
          tooltip: { enabled: false },
        },
      },

      plugins: [
        {
          id: 'freshserviceLabels',
          afterDraw(chart) {
            const { ctx, chartArea, data } = chart;
            const meta = chart.getDatasetMeta(0);

            if (!meta.data || meta.data.length === 0) return;

            ctx.save();

            const centerX = (chartArea.left + chartArea.right) / 2;
            const centerY = (chartArea.top + chartArea.bottom) / 2;

            meta.data.forEach((arc, i) => {
              const angle = (arc.startAngle + arc.endAngle) / 2;

              const startX = centerX + Math.cos(angle) * arc.outerRadius;
              const startY = centerY + Math.sin(angle) * arc.outerRadius;

              const lineLength = 25;
              const endX =
                centerX + Math.cos(angle) * (arc.outerRadius + lineLength);
              const endY =
                centerY + Math.sin(angle) * (arc.outerRadius + lineLength);

              const ctrlOffset = 10;
              const ctrlX =
                centerX + Math.cos(angle) * (arc.outerRadius + ctrlOffset);
              const ctrlY =
                centerY + Math.sin(angle) * (arc.outerRadius + ctrlOffset);

              ctx.strokeStyle = '#9CA3AF';
              ctx.lineWidth = 1;
              ctx.beginPath();
              ctx.moveTo(startX, startY);
              ctx.quadraticCurveTo(ctrlX, ctrlY, endX, endY);
              ctx.stroke();

              ctx.fillStyle = '#4B5563';
              ctx.font = '14px system-ui, -apple-system, sans-serif';

              const isRightSide = Math.cos(angle) >= 0;
              ctx.textAlign = isRightSide ? 'left' : 'right';
              ctx.textBaseline = 'middle';

              const labelX = endX + (isRightSide ? 8 : -8);
              const labelText = `${data.labels[i]} (${data.datasets[0].data[i]})`;

              ctx.fillText(labelText, labelX, endY);
            });

            ctx.restore();
          },
        },
      ],
    });
  }

  willDestroy() {
    if (this.chartInstance) {
      this.chartInstance.destroy();
      this.chartInstance = null;
    }
  }
}
