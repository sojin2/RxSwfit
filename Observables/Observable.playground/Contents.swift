import UIKit
import RxSwift
import Foundation

let observable = Observable.of(1, 2, 3, 4)
observable.subscribe()

observable.subscribe { element in
    print("Observable로부터 \(element)를 전달받았습니다.")
} onError: { error in
    print(error.localizedDescription)
} onCompleted: {
    print("Observable이 정상적으로 종료되었습니다.")
} onDisposed: {
    print("Observable이 버려졌습니다.")
}


// 메모리 누수
/*
observable.subscribe(onNext: { [weak self] _ in
    self?.someFunc()
})

observable.subscribe(with: self) { strongSelf, _ in
    strongSelf.someFunc()
}
*/



// just - 하나의 요소만 방출
let justStringObservable = Observable.just("hello world")
let justIntObservable = Observable.just(100)

justStringObservable.subscribe (onNext: { element in
    print(element)
}, onCompleted: {
    print("completed")
})

justIntObservable.subscribe (onNext: { element in
    print(element)
}, onCompleted: {
    print("completed")
})

let justObervable: Observable<String> = Observable.just("Hello World")



// of - 여러개의 요소들을 순차적으로 방출
let ofObservable = Observable.of("hi", "my", "name", "is", "sojin")

ofObservable.subscribe { element in
    print(element)
} onCompleted: {
    print("completed")
}

/* 주의 사항
 of()안에 들어가는 요소들은 타입추론되어서 타입 제한이 생기기때문에 하나의 타입으로 통일 시켜줘야합니다.


// Error
let ofObservable = Observable.of("hi", "i'm", 3, "years", "old", "sojin")

// Ok
let ofObservable: Observable<Any> = Observable.of("hi", "i'm", 3, "years", "old", "sojin")

*/



// from - 배열로 요소를 받은 후에 하나하나 요소로서 방출해주는 연산자
// 배열의 값 하나하나를 Observable의 요소로서 방출시키고 싶다면 from을 사용

let fromObservable = Observable.from(["Apple", "is", "Red"])

fromObservable.subscribe{ element in
    print(element)
} onCompleted: {
    print("completed")
}

/*
 
 of와 from의 다른점이 뭔데???
 : from은 배열을 출력함

let ofObservable = Observable.of(["Apple", "is", "Red"])
let fromObservable = Observable.from(["Apple", "is", "Red"])

ofObservable.subscribe { element in
    print(element)
} onCompleted: {
    print("completed")
}


fromObservable.subscribe { element in
    print(element)
} onCompleted: {
    print("completed")
}

*/



// range - for문과 같이 Observable에서도 요소를 단순히 연속적으로 반복 방출 시킬 수 있도록 도와주는 연산자
// Int 타입으로 제한이걸려있음
// 단순 반복 요소를 방출하는 Observable를 만들고 싶다면 range 사용
// from으로도 동일하게 표현 가능 (스타일 차이)

let rangeObservable = Observable.range(start: 0, count: 10)

rangeObservable.subscribe(onNext: { element in
    print(element)
})

/*
from을 이용하여 충분히 표현 가능

let fromObservable = Observable.from(0..<10)
rangeObservable.subscribe(onNext: { element in
    print(element)
})
 */



// empty - 초기화
// 즉시 completed되는 Observable이나 element가 0개인 Observable을 의도적으로 리턴하고 싶을 때에도 유용하게 사용될 수 있음

/* 일반적인 방식 (Error)
let emptyObservable: Observable = Observable<Any>()
*/

let emptyObservable: Observable = Observable<Any>.empty()



// never - Observable이 아무런 이번트도 방출시키지 않도록 해줌
// 단, onDisposed 제외

let neverObservable = Observable<Int>.never()


// disposable - 구독 취소

// 각각 직접 호출하여 취소
Observable.just(100).subscribe(onNext: { element in
    print(element)
}).dispose()

let disposeBag = DisposeBag()
/*
// 한번에 구독 취소
let disposeBag = DisposeBag()
observable.subscribe(onNext: { element in
    print(element)
}).disposed(by: disposeBag)

// 혹은
disposeBag = nil
*/



// create - 자유 자재로 원하는 시점에 원하는 이벤트를 방출
let customObservable = Observable<String>.create { observer in
    observer.onNext("hi i'm sojin")
    observer.onCompleted()
    
    return Disposables.create()
}

customObservable.subscribe (onNext: { element in
    print(element)
}, onCompleted: {
    print("onCompleted")
}).disposed(by: disposeBag)

// 함수

func customObservable2() -> Observable<String> {
    return Observable<String>.create { observer in
        observer.onNext("hi i'm sojin")
        observer.onCompleted()
        
        return Disposables.create()
    }
}

customObservable2().subscribe(onNext: { element in
    print(element)
}, onCompleted: {
    print("onCompleted")
}).disposed(by: disposeBag)



// deferred - Observable이 생성되는 시점을 구독자에 의해서 구독되기 전까지 미뤄주는 역할
// 굳이 구독되기 전에 미리 계산할 필요가 없는 Observable들에 사용 (구독하기도 전에 불필요하게 소요되는 시간 낭비를 줄임)

/*
// 선언부
public static func deferred(_ observableFactory: @escaping () throws -> Observable<Element>)

let deferredObservable = Observable<String>.deferred {
    // 여기에 Observable을 리턴
}
*/
 

// 사용하기

/* 아래 observable을 미루기
 
let observable = Observable.just("sojin")
 
*/
 
let deferredOb = Observable<String>.deferred {
    return Observable.just("sojin deferred")
}

// 구독시 실행
deferredOb.subscribe(onNext: { element in
    print(element)
})


// 구현
let mathObservable = Observable.just(doSomeMath())

func doSomeMath() {
    print("1 + 1 = 2")
}

/*
위치 권한과 같은 가장 최신 상태를 불러올때 사용하면 좋음

무거운 작업의 Observable을 만들어 사용할 때에는 deferred를 이용해서 구독하는 시점과 동시에 작업을 시작할 수 있도록하여 쓸데없는 낭비를 막자
구독과 동시에 최신값이 필요한 경우 Obserbable을 deferred로 감싸서 사용하도록 한다.
 */


