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
        datasets: [{
          data: chartData.data.map((d) => d.value),
          backgroundColor: chartData.data.map((d) => d.color),
          borderWidth: 0,
        }],
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        cutout: '68%',
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            backgroundColor: '#1f2937',
            padding: 10,
            bodyFont: { size: 13 },
            callbacks: {
              label: function(context) {
                return `${context.label}: ${context.parsed}`;
              }
            }
          }
        }
      },
      plugins: [{
        id: 'customLabelsWithArrows',
        afterDraw: (chart) => {
          const { ctx, chartArea, data } = chart;
          const meta = chart.getDatasetMeta(0);
          const centerX = (chartArea.left + chartArea.right) / 2;
          const centerY = (chartArea.top + chartArea.bottom) / 2;
          
          // For single segment (like "Open (8)")
          if (data.datasets[0].data.length === 1) {
            const label = data.labels[0];
            const value = data.datasets[0].data[0];
            
            // Draw curved line from bottom of chart
            const startX = centerX;
            const startY = centerY + (chartArea.bottom - centerY) * 0.6;
            const endX = centerX;
            const endY = chartArea.bottom + 30;
            
            ctx.strokeStyle = '#9ca3af';
            ctx.lineWidth = 1.5;
            ctx.beginPath();
            ctx.moveTo(startX, startY);
            ctx.quadraticCurveTo(startX, startY + 15, endX, endY - 10);
            ctx.lineTo(endX, endY);
            ctx.stroke();
            
            // Draw label
            ctx.fillStyle = '#374151';
            ctx.font = '14px system-ui';
            ctx.textAlign = 'center';
            ctx.fillText(`${label} (${value})`, endX, endY + 5);
            return;
          }
          
          // For multiple segments
          data.datasets[0].data.forEach((value, i) => {
            const label = data.labels[i];
            const arc = meta.data[i];
            const angle = (arc.startAngle + arc.endAngle) / 2;
            
            // Calculate positions based on segment index
            let labelConfig;
            if (i === 0) { // High - top right
              labelConfig = {
                startRadius: 0.85,
                endX: chartArea.right - 20,
                endY: chartArea.top + 30,
                textAlign: 'right'
              };
            } else if (i === 1) { // Medium - bottom left
              labelConfig = {
                startRadius: 0.85,
                endX: chartArea.left + 30,
                endY: chartArea.bottom - 20,
                textAlign: 'left'
              };
            } else { // Low - right side
              labelConfig = {
                startRadius: 0.85,
                endX: chartArea.right - 20,
                endY: centerY + 50,
                textAlign: 'right'
              };
            }
            
            // Calculate start point on chart edge
            const radius = arc.outerRadius;
            const startX = centerX + Math.cos(angle) * (radius * labelConfig.startRadius);
            const startY = centerY + Math.sin(angle) * (radius * labelConfig.startRadius);
            
            // Draw curved arrow
            ctx.strokeStyle = '#9ca3af';
            ctx.lineWidth = 1.5;
            ctx.beginPath();
            ctx.moveTo(startX, startY);
            
            const controlX = (startX + labelConfig.endX) / 2;
            const controlY = (startY + labelConfig.endY) / 2;
            ctx.quadraticCurveTo(controlX, controlY, labelConfig.endX, labelConfig.endY);
            ctx.stroke();
            
            // Draw label text
            ctx.fillStyle = '#374151';
            ctx.font = '14px system-ui';
            ctx.textAlign = labelConfig.textAlign;
            ctx.fillText(`${label} (${value})`, labelConfig.endX, labelConfig.endY);
          });
        }
      }]
    });
  }
}