import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progress-chart"
export default class extends Controller {
  static values = {
    dataset: String
  }
  connect() {
    const ctx = this.element

    let datasets = []

    const chartData = JSON.parse(this.datasetValue)
    if (!chartData.length) return

    const init = chartData.at(0)
    const initDate = new Intl.DateTimeFormat('es-ES', {
      day: 'numeric',
      month: 'long',
      year: 'numeric'
    }).format(new Date(init.created_at))

    const last = chartData.at(-1)
    const lastDate = new Intl.DateTimeFormat('es-ES', {
      day: 'numeric',
      month: 'long',
      year: 'numeric'
    }).format(new Date(last.created_at))

    datasets.push({
      label: `Inicial (${initDate})`,
      data: [init.weight, init.chest, init.arms, init.waist, init.hip, init.thighs, init.calves],
      fill: true,
      backgroundColor: 'rgba(28, 28, 41, 1.0)',
      borderColor: 'rgb(28, 28, 41)',
      pointBackgroundColor: '#f3ede9',
      pointBorderColor: 'rgb(28, 28, 41)',
    })

    if (init.id != last.id) {
      datasets.unshift({
        label: `Actual (${lastDate})`,
        data: [last.weight, last.chest, last.arms, last.waist, last.hip, last.thighs, last.calves],
        fill: true,
        backgroundColor: 'rgba(225, 254, 0, 0.97)',
        borderColor: 'rgb(225, 254, 0)',
        pointBackgroundColor: 'rgb(28, 28, 41)',
        pointBorderColor: 'rgb(225, 254, 0)',
      })
    }

    const data = {
      labels: [
        'Peso (kg)',
        'Pecho (cm)',
        'Brazos (cm)',
        'Cintura (cm)',
        'Cadera (cm)',
        'Muslos (cm)',
        'Pantorrillas (cm)'
      ],
      datasets
    };

    const config = {
      type: 'radar',
      data: data,
      options: {
        elements: {
          line: {
            borderWidth: 3
          }
        }
      },
    };

    new Chart(ctx, config);
  }
}
