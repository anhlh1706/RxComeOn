import UIKit
import RxSwift
import RxCocoa

// Subscription - một đăng ký
// Subcriber    - người đăng ký
// Observable   - nguồn phát
// Observer     - nguồn nhận
// Subjects     - kết hợp cả Observable & Observer, khi nhận onNext sẽ bắn sự kiện cho Subcriber
// Trail        - một wrapper struct với một thuộc tính là một Observable Sequence
// toArray      - đưa tất cả phần tử được phát ra của Observavle thành 1 array. Bạn sẽ nhận được array đó khi Observable kia kết thúc.
// map          - toán tử huyền thoại với mục đích duy nhất là biến đổi kiểu dữ liệu này thành kiểu dữ liệu khác.
// flatMap      - làm phẳng các Observables thành 1 Observable duy nhất. Và các phần tử nhận được là các phần tử từ tất cả các Observables kia phát ra. Không phân biệt thứ tự đăng ký.
// flatMapLatest- tương tư cái flatMap thôi. Nhưng điểm khác biệt ở chỗ chỉ nhận giá trị được phát đi của Observable cuối cùng tham gia vào.
// materialize  - thay vì nhận giá trị được phát đi. Nó biến đổi các events thành giá trị để phát đi. Lúc này, error hay completed thì cũng là 1 giá trị mà thôi.
//dematerialize - thì ngược lại materialize. Giải nén các giá trị là events để lấy giá trị thật sự trong đó.

// MARK: - Marble diagrams
// - Dấu | biểu tượng cho kết thúc (completed)
// - Dấu X biểu tượng cho lỗi (error)

// MARK: - Side Effect
// là những thay đổi phía bên ngoài của một scope.
// Trong RxSwift, Side Effect được dùng để thực hiện một tác vụ nào đó nằm bên ngoài của scope mà không làm ảnh hưởng tới scope đó.

// MARK: - Dispose
// Với dispose, phải tự gọi .dispose() trong deinit()
// .disposed(by: disposeBag) sẽ tự gọi .dispose() cho các disposable bên trong khi bản thân disposeBag được giải phóng

// MARK: - Retain cycle
// ViewController -> DisposeBag -> Disposable -> Observable -> ViewController

/*
Tạo observable đơn giản
 - just: Phát ra phần tử duy nhất và kết thúc
 - of: Phát ra lần lượt các phần tử cung cấp và kết thúc
 - from: Tương tự như of mà tham số truyền vào là 1 array, tiết kiệm thời gian ngồi gõ code
 - range: Tương tự một vòng for
 - deferred : Chờ đến lúc block trả về giá trị mới emit
 
Các observable đặc biết xí
 - empty: Không phát gì hết mà kết thúc completed
 - never: Không phát ra gì cả. Kể cả error hay completed
 - error: Phát ra mỗi error và kết thúc
*/

// MARK: - Subject
/*
 PublishSubject: Khởi đầu empty và chỉ emit các element mới cho Subscriber của nó.
 BehaviorSubject: Khởi đầu với một giá trị khởi tạo và sẽ relay lại element cuối cùng của chuỗi cho Subscriber mới.
 ReplaySubject: Khởi tạo với một kích thước bộ đệm cố định, sau đó sẽ lưu trữ các element gần nhất vào bộ đệm này và relay lại các element chứa trong bộ đệm cho các Subscriber mới. Bộ đệm không bị xoá sau khi nhận .error hoặc .complete, các phần subcriber đến sau khi .error hoặc .complete vẫn được relay bộ đệm, chỉ sau khi .dispose thì mới mất bộ đệm và các subcriber đến sau sẽ k nhận relay gì.
 AsyncSubject: Chỉ phát ra sự kiện .next cuối cùng trong chuỗi và chỉ khi subject nhận được .completed
 PublishRelay & BehaviorRelay : là các subject được bọc lại (wrap), nhưng chúng chỉ chấp nhận .next. Không thể thêm các .error hay .completed -> Không bao giờ kết thúc
 */


// MARK: - Trail
// Là observable đặc biệt, chỉ đảm đương 1 vài tính chất của observable.
/*
  - Single          - Emit duy nhất 1 element (onSuccess) hoặc 1 error
  - Completable     - Emit duy nhất 1 complete hoặc 1 error (không emit element)
  - Maybe           - Emit 1 element, 1 complete hoặc 1 error. (Single + Completable)
 */

// MARK: - RxCocoa Trail
/*
 - Driver giúp bạn đưa dữ liệu lên UI Control mà không cần lo lắng gì tới Main Thread hoặc lỗi. Thích hợp với Model State.
 - Signal tương tự như Driver. Nhưng sẽ không lưu trữ bộ đệm. Thích hợp với Model Event.
 - ControlProperty là một phần của Observable/ObservableType. Nó đại diện cho các property của các thành phần UI.
 - ControlEvent là một phần của Observable/ObservableType. Nó đại diện cho các sự kiện của các thành phần UI.
 - Chúng ta có thể tạo các BindingProperty để binding dữ liệu. Đó là các Binder.
*/
// MARK: - Instance
func doStuff(dis: DisposeBag) {
    // A small for loop
//    Observable.range(start: 0, count: 1).subscribe(onNext: { value in
//        print(value)
//    }).disposed(by: DisposeBag())
    
    // Bắn ra lần lượt các phần tử rồi kết thúc, với mảng thì vẫn bắn cả mảng 1 lần
//    Observable.of([1, 2]).subscribe(onNext: { v in
//        print(v)
//    }).disposed(by: DisposeBag())
    
    // Bắn ra từng phần tử trong mảng
//    Observable.from([1, 2]).subscribe(onNext: { v in
//        print(v)
//    }).disposed(by: DisposeBag())
    
    // Phải return disposable để kết thúc đăng ký từ bên ngoài (lúc sử dụng)
//    Observable<String>.create { observer -> Disposable in
//        observer.onNext("Hihi1")
//        observer.onCompleted() // Nếu không complete ở đây, observable sẽ kết thúc lúc disposeBag được giải phóng
//        observer.onNext("Hihi2")
//        return Disposables.create()
//    }.subscribe(onNext: { a in
//        print(a)
//    }, onCompleted: {
//        print("complete")
//    }, onDisposed: {
//        print("dispose")
//    }).disposed(by: dis)
    
    // MARK: - PublishSubject
//    let publishSubject = PublishSubject<Int>()
//    publishSubject.onNext(2)
//    publishSubject.subscribe(onNext: { value in
//        print(value)  // Không emit cho đến khi nhận onNext mới
//    }).disposed(by: dis)
//
    // MARK: - BehaviorSubject
//    let behaviorSubject = BehaviorSubject<Int>(value: 1)
//    behaviorSubject.subscribe(onNext: { value in
//        print(value)  // Emit ngay lập tức giá trị cuối cùng
//    }).disposed(by: dis)
    
    // MARK: - ReplaySubject
//    let replaySubject = ReplaySubject<Int>.create(bufferSize: 2) //.createUnbounded()
//    replaySubject.onNext(1)
//    replaySubject.onNext(2)
//    replaySubject.onNext(3)
//    replaySubject.onError(SomeError.some) // Vẫn giữ cache sau khi .error hoặc .complete, chỉ sau khi .dispose() thì các giá trị mới được loại bỏ
//    replaySubject.subscribe(onNext: { value in
//        print(value) // Emit ngay lập tức 2 giá trị cuối (theo bufferSize)
//    }, onError: { err in
//        print(err)
//    }).disposed(by: dis)
    
    // MARK: - AsyncSubject
//    let asyncSubject = AsyncSubject<Int>()
//    asyncSubject.onNext(1)
//    asyncSubject.onNext(2)
//    asyncSubject.subscribe(onNext: { a in
//        print(a)                      // Không emit, ngay cả khi onNext
//    }, onCompleted: {
//        print("completed")
//    }).disposed(by: dis)
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//        asyncSubject.onCompleted()    // Chỉ emit giá trị cuối ngay trước khi complete
//    }
    
    // MARK: - Single
//    Single<String>.create { single -> Disposable in
//        single(.success("z"))
//        single(.error(SomeError.some))    // Chỉ bắn 1 kết quả, dòng này sẽ k được chạy
//        return Disposables.create()
//    }.subscribe().disposed(by: dis)
    
    // MARK: - Operators
//    .scan(0, accumulator: +).subscribe(onNext: // mỗi lần onNext đều cộng dồn với giá trị hiện tại rồi mới phát ra
    
//    Observable.just(2).toArray()      // Từ Observable<Int> sang Single<[Int]>
//    Observable.just(2).materialize()  // Chuyển gía trị thành sự kiện : 2 -> onNext(2)
//    PublishSubject().dematerialize()  // Ngược lại với materialize(), chuyển .next thành value
    
//         roomChat
//            .filter{
//                guard $0.error == nil else {  // bắt error
//                    print("Lỗi phát sinh: \($0.error!)")
//                    return false
//                }
//                return true
//            }
//            .dematerialize()
//            .subscribe(onNext: { msg in
//                print(msg)
//            })
//            .disposed(by: bag)
    
//    let obser = Observable<Int>.create { ob -> Disposable in
//
//        var value = 1
//        let source = DispatchSource.makeTimerSource(queue: .main)
//        source.setEventHandler {
//            if value < 8 {
//                ob.onNext(value)
//                value += 1
//            }
//        }
//        source.schedule(deadline: .now(), repeating: 1, leeway: .nanoseconds(0))
//        source.resume()
//
//        return Disposables.create {
//            source.suspend()
//        }
//    }
//
    
//    let a = PublishSubject<Int>()
//    let b = PublishSubject<Int>()
//    let c = PublishSubject<Int>()
    
    // .merge : Cứ có .next là gọi
    // .combineLatest: Gọi sau khi tất cả gọi xong, rồi từ đó gọi tiếp mỗi lần có .next
    // .zip : Gọi theo index (0, 0, 0), (1, 1, 1)
    
//    Observable.merge(a, b, c).subscribe(onNext: { d in
//        print(d) // Kiểu dữ liệu chung của các element được merge, trả về giá trị của thằng .next
//    }).disposed(by: dis)
    
//    Observable.combineLatest(a, b, c).subscribe(onNext: { d in
//        print(d) // Kiểu tuple của các element, khi nào tất cả đều emit thì ms bắt đầu gọi, sau đó gọi mỗi lần emit
//    }).disposed(by: dis)
    
//    Observable.zip(a, b, c).subscribe(onNext: { d in
//        print(d) // Kiểu tuple của các element, khi nào tất cả đều emit thì ms bắt đầu gọi theo đúng index (0, 0), (1, 1) chứ k phải cứ cuối cùng là lấy
//    }).disposed(by: dis)
    
//    a.onNext(1)
//    b.onNext(2)
//    c.onNext(3)
//    a.onNext(4)
//    c.onNext(5)
//    c.onNext(8)
    
}


