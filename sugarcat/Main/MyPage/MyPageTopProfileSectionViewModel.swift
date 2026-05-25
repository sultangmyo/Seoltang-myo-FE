import Foundation

class MyPageViewModel: ObservableObject {
    // 뷰에서 관찰할 상태 변수들
    @Published var catName: String = ""
    @Published var catAgeInfo: String = ""
    @Published var catBirth: String = ""
    
    @Published var myNickname: String = ""
    @Published var mates: [String] = []
    
    @Published var isLoading: Bool = false
    
    /// 1. 마이페이지에 필요한 모든 정보(고양이 + 유저)를 백엔드에서 가져오는 함수
    func fetchMypageData() {
        self.isLoading = true
        
        // 실제 구현 시에는 DispatchGroup을 쓰거나 순차적으로 두 API를 호출합니다.
        // 예시:
        // 1) GET /cats/profile -> CatInfoResponseDTO
        // 2) GET /users/me      -> UserInfoResponseDTO
        
        // --- 데이터 연결 확인용 시뮬레이션 ---
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // [API 1] 고양이 정보 로드 및 가공
            let catDTO = CatInfoResponseDTO(name: "나비", birthDate: "2014.05.22", diagnosedDate: "2025.10.12")
            self.processCatData(dto: catDTO)
            
            // [API 2] 유저 및 패밀리 정보 로드
            let userDTO = UserInfoResponseDTO(
                nickname: "고대모",
                family: [FamilyMemberDTO(nickname: "엄마"), FamilyMemberDTO(nickname: "아빠")]
            )
            self.processUserData(dto: userDTO)
            
            self.isLoading = false
        }
    }
    
    /// 2. 사용자 닉네임을 백엔드에 보내서 수정하는 함수
    func updateNickname(newNickname: String, completion: @escaping (Bool) -> Void) {
        // Request DTO 생성
        let requestDTO = UpdateUserRequestDTO(nickname: newNickname)
        
        print("🚀 백엔드로 닉네임 수정 요청: \(requestDTO.nickname)")
        
        // 백엔드 연결
        /*
        guard let url = URL(string: "https://api.sugarcat.com/v1/users/nickname") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(requestDTO)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if error == nil {
                DispatchQueue.main.async {
                   
                    self?.myNickname = newNickname
                    completion(true)
                }
            } else {
                completion(false)
            }
        }.resume()
        */
        
        // 시뮬레이션 성공 처리
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.myNickname = newNickname // 즉시 반영
            completion(true)
        }
    }
    
    // 고양이 데이터 전처리
    private func processCatData(dto: CatInfoResponseDTO) {
        self.catName = dto.name
        if let birthStr = dto.birthDate, !birthStr.isEmpty {
            self.catBirth = birthStr
            self.catAgeInfo = calculateAge(from: birthStr)
        } else {
            self.catBirth = "생일 정보 없음"
            self.catAgeInfo = "나이 모름"
        }
    }
    
    // 유저 및 가족 데이터 전처리
    private func processUserData(dto: UserInfoResponseDTO) {
        self.myNickname = dto.nickname
        // family DTO 배열에서 닉네임 문자열만 쏙 뽑아서 배열로 저장
        self.mates = dto.family.map { $0.nickname }
    }
    
    // 나이 계산 함수
    private func calculateAge(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateString.contains("-") ? "yyyy-MM-dd" : "yyyy.MM.dd"
        guard let birthDate = formatter.date(from: dateString) else { return "나이 미정" }
        
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        if let age = ageComponents.year {
            return "\(age)살"
        }
        return "나이 미정"
    }
}
