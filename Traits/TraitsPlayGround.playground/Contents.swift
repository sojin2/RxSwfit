import UIKit

import RxSwift
import Darwin

// single : 한 가지의 값 또는 에러의 형태로 보장 받을 수 있을 때 사용
func singleObservable() -> Single<Any> {
    return Single.create { single in
        single(.success(<#T##Any#>))
        single(.failure(<#T##Error#>))
        
        return Disposables.create()
    }
}


/*
 사용 예시: API request를 통해 하나의 보장된 요소나 에러를 받을 때 유용

func getRepo(_ repo: String) -> Single<[String: Any]> {
    return Single<[String: Any]>.create { single in
        let task = URLSession.shared.dataTask(with: URL(string: "https://api.github.com/repos/\(repo)")!) { data, _, error in
            if let error = error {
                single(.failure(error))
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                  let result = json as? [String: Any] else {
                single(.failure(DataError.cantParseJSON))
                return
            }

            single(.success(result))
        }

        task.resume()

        return Disposables.create { task.cancel() }
    }
}

getRepo("ReactiveX/RxSwift")
    .subscribe { event in
        switch event {
            case .success(let json):
                print("JSON: ", json)
            case .failure(let error):
                print("Error: ", error)
        }
    }
    .disposed(by: disposeBag)

 */

// Completable - 어떠한 액션이 성공했는지 또는 에러가 발생하는지와 같은 두 가지 타입만 받고 싶을 때

func completableObservable() -> Completable {
    return Completable.create { completable in
        completable(.completed)
        completable(.error(<#T##Error#>))
        
        return Disposables.create()
    }
}

// Maybe - 이벤트에서 요소를 방출 시킬 수도 있지만 꼭 요소를 방출 시킬 필요가 없는 경우에 유용하게 사용

// Maybe는 Single의 .sucess()특성도 지녔다보니 제네릭 타임으로 꼭 방출할 요소를 타입으로 지정해줘야 함

func maybeObservable() -> Maybe<Any> {
    return Maybe.create { maybe in
        maybe(.success(<#T##Any#>))
        maybe(.error(<#T##Error#>))
        maybe(.completed)
        return Disposables.create()
    }
}

