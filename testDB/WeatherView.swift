import SwiftUI

func get(value: String) -> String { //데이터에 값을 확인하고 막대기 색깔 바꾸기
    switch value {
    case "Rain":
        return "cloud.rain.fill"
    case "Clear":
        return "sun.max.fill"
    case "Clouds":
        return "cloud.fill"
    case "Snow":
        return "cloud.snow.fill"
    case "Thunderstorm":
        return "cloud.bolt.rain.fill"
    case "Fog":
        return "smoke.fill"
    case "Mist":
        return "smoke.fill"
    default:
        return "sun.max.fill"
    }
}
func getName(value: String) -> String { //데이터에 값을 확인하고 막대기 색깔 바꾸기
    switch value {
    case "Rain":
        return "비오는 날씨"
    case "Clear":
        return "맑은 날씨"
    case "Clouds":
        return "구름낀 날씨"
    case "Snow":
        return "눈오는 날씨"
    case "Thunderstorm":
        return "천둥번개치는 날씨"
    case "Fog":
        return "안개가 짙은 날씨"
    case "Mist":
        return "안개가 자욱한 날씨"
    default:
        return "sun.max.fill"
    }
}
struct WeatherView: View {
    @State private var weatherData: WeatherData?
    @State private var isLoading = false
    
    private let apiKey = "0c9c47a29bc6f0f969abf7fb1f365b75" // 발급받은 개인 API 키로 대체해야 합니다
    private let city = "Daejeon" // 원하는 도시나 위치로 수정해도 좋습니다
    //Rain //Clear
    var body: some View {
        VStack {
            if isLoading {
                Text("Loading...")
            } else if let weather = weatherData {
                VStack {
                    Image(systemName: get(value: weather.weather[0].main)) // 비가 오는 이미지 또는 해가 뜨는 이미지

                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .padding()
                    Text("현재 날씨: \(getName(value: weather.weather[0].main))")
                        .font(.largeTitle)
                        .padding()
                    Text("현재 온도: \(Int(weather.main.temp))°C")
                        .font(.title)
                    Text("현재 습도: \(Int(weather.main.humidity))%")
                        .font(.subheadline)
                    
                    
                    
                }
            } else {
                Text("Failed to fetch weather data.")
            }
        }
        .padding()
        .onAppear {
            fetchWeather()
        }
    }
    
    func fetchWeather() {
        isLoading = true
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
            
            guard let data = data, error == nil else {
                print("Error fetching weather data: \(error?.localizedDescription ?? "")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(WeatherData.self, from: data)
                
                DispatchQueue.main.async {
                    weatherData = decodedData
                }
            } catch {
                print("Failed to decode weather data: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
