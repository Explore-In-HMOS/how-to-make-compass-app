import { sensor } from '@kit.SensorServiceKit';

@Entry
@Component
struct Index {
  @State azimuth: number = 0

  onPageShow() {
    try {
      sensor.on(sensor.SensorId.ROTATION_VECTOR, (data: sensor.RotationVectorResponse) => {
        const x = data.x
        const y = data.y
        const z = data.z
        const w = data.w

        const SINY_COSP = 2 * (w * z + x * y)
        const COSY_COSP = 1 - 2 * (y * y + z * z)
        const azimuthRad = Math.atan2(SINY_COSP, COSY_COSP)
        const azimuthDeg = (azimuthRad * 180 / Math.PI + 360) % 360

        this.azimuth = Math.round(azimuthDeg)
      }, {
        interval: 100_000_000
      })
    } catch (error) {
      //
    }
  }

  aboutToAppear() {
    this.onPageShow()
  }

  aboutToDisappear() {
    sensor.off(sensor.SensorId.ROTATION_VECTOR)
  }

  build() {
    NavDestination() {

      Stack() {
        Rect()
          .width('100%')
          .height('100%')

        Column({ space: 20 }) {
          Text(`Azimuth: ${this.azimuth}°`)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)

          Image($r('app.media.compass_vector'))
            .width(150)
            .height(150)
            .rotate({ angle: -this.azimuth })
        }
      }
      .width('100%')
      .height('100%')

    }
    .hideTitleBar(true)

  }
}