/// LDT proof — broker constraint matrix + `~Copyable` live session.
///
/// Claim: A brokerage's per-axis mutability constraints can be encoded at
/// the Swift type level using `~Copyable` sessions and `consuming` functions
/// such that locked axes become compile-time errors to swap in place.
///
/// Background: the substrate already has a runtime constraint matrix in
/// `wrkstrm-finance/public/universal/spm/domain/finance/common-broker/
/// Sources/CommonBroker/BrokerCapabilities.swift`. This proof extends the
/// idea to the type system, mirroring the AI-provider-constraint design
/// in `feedback_swift-identifiers-romaji-not-katakana.md`'s neighbor work
/// on `CliaProviderConstraints` for clia-app.
///
/// Per-axis convention:
///   - `canSwapXxxLive == true`  → `mutating func swapXxx(_:)`
///   - `canSwapXxxLive == false` → `consuming func switchingXxx(_:) -> Self`
///
/// Run: `swift 2026-04-29-broker-constraint-matrix-and-copyable-session.swift`

import Foundation

// MARK: - Constraint matrix

enum Broker: String, CaseIterable, Sendable {
  case tradier
  case schwab
  case alpaca
  case publicCom = "public.com"
}

struct BrokerConstraints: Sendable {
  /// Account = which account at the broker (primary, IRA, joint, etc.).
  /// Most brokers let you read across accounts but writing to a different
  /// account requires a fresh session: a different OAuth scope or a
  /// different api token, depending on the broker.
  let canSwapAccountLive: Bool

  /// Strategy = the trading approach in flight (momentum, mean-reversion,
  /// swing, scalp). Always live-swappable at the application layer; the
  /// broker doesn't see this.
  let canSwapStrategyLive: Bool

  /// Instrument = the symbol or contract under attention. Always
  /// live-swappable; instrument is just a piece of state in our process.
  let canSwapInstrumentLive: Bool
}

extension Broker {
  var constraints: BrokerConstraints {
    switch self {
    case .tradier:
      BrokerConstraints(
        canSwapAccountLive: false,    // Tradier scopes tokens to a single account
        canSwapStrategyLive: true,
        canSwapInstrumentLive: true
      )
    case .schwab:
      BrokerConstraints(
        canSwapAccountLive: false,    // Schwab account-scoped OAuth
        canSwapStrategyLive: true,
        canSwapInstrumentLive: true
      )
    case .alpaca:
      BrokerConstraints(
        canSwapAccountLive: true,     // Alpaca paper/live distinction is a header flip
        canSwapStrategyLive: true,
        canSwapInstrumentLive: true
      )
    case .publicCom:
      BrokerConstraints(
        canSwapAccountLive: false,
        canSwapStrategyLive: true,
        canSwapInstrumentLive: true
      )
    }
  }
}

// MARK: - Live session as ~Copyable

struct TradeSession: ~Copyable, Sendable {
  let broker: Broker
  let account: String
  var strategy: String
  var instrument: String

  // Live-swappable axes use `mutating`.
  mutating func swapStrategy(to s: String) { strategy = s }
  mutating func swapInstrument(to i: String) { instrument = i }

  // Locked axes use `consuming` — old session is unusable after the swap.
  // The compiler enforces it: any use of `self` after this returns is an
  // "used after consume" diagnostic, which IS the lock proof.
  consuming func switchingAccount(to acct: String) -> TradeSession {
    TradeSession(
      broker: broker,
      account: acct,
      strategy: strategy,
      instrument: instrument
    )
  }
}

// MARK: - Positive proof (runtime asserts)
//
// `~Copyable` values can't live at global scope in script mode — wrap the
// run in a local function so the consume happens in a fresh local frame.

func runPositiveProof() {
  // Live strategy swap on Tradier — should mutate in place.
  var session = TradeSession(
    broker: .tradier,
    account: "primary",
    strategy: "momentum",
    instrument: "AAPL"
  )
  session.swapStrategy(to: "mean-reversion")
  precondition(
    session.strategy == "mean-reversion",
    "live strategy swap should mutate in place"
  )
  session.swapInstrument(to: "MSFT")
  precondition(session.instrument == "MSFT", "instrument should swap live")

  // Account swap — locked on Tradier — must consume the old session.
  let session2 = session.switchingAccount(to: "ira")
  precondition(session2.account == "ira", "consumed swap returns new account")
  precondition(session2.broker == .tradier, "broker preserved across consume")

  // Constraint matrix invariants
  precondition(
    Broker.tradier.constraints.canSwapAccountLive == false,
    "tradier locks accounts"
  )
  precondition(
    Broker.alpaca.constraints.canSwapAccountLive == true,
    "alpaca account-swappable"
  )
  precondition(
    Broker.allCases.allSatisfy { $0.constraints.canSwapStrategyLive },
    "strategy is always live-swappable across brokers"
  )
}

// MARK: - Negative proof (compile-time refusal)
//
// Each block below is currently commented out so the file compiles. Uncomment
// any one and re-run `swift <this-file>` — the compiler should refuse with
// the error in the trailing comment. THIS is the type-level enforcement; the
// preconditions above only check runtime behavior on the allowed paths.

func runNegativeProof_useAfterConsume_wouldFail() {
  // var session = TradeSession(broker: .tradier, account: "primary",
  //                            strategy: "momentum", instrument: "AAPL")
  // let next = session.switchingAccount(to: "ira")
  // session.swapStrategy(to: "scalp")
  // ^ error: 'session' consumed more than once / 'session' used after consume
  // _ = next
}

func runNegativeProof_implicitCopy_wouldFail() {
  // let session = TradeSession(broker: .tradier, account: "primary",
  //                            strategy: "momentum", instrument: "AAPL")
  // let twin = session
  // ^ error: cannot copy value of noncopyable type 'TradeSession'
  // _ = twin
}

func runNegativeProof_storedAsLetThenMutated_wouldFail() {
  // let session = TradeSession(broker: .tradier, account: "primary",
  //                            strategy: "momentum", instrument: "AAPL")
  // session.swapStrategy(to: "scalp")
  // ^ error: cannot use mutating member on immutable value: 'session' is a 'let' constant
}

// MARK: - Run

runPositiveProof()
print("ok: broker constraint matrix + ~Copyable TradeSession enforces locked-account axis at type level (positive). Uncomment any runNegativeProof_* body to feel the compile-time refusal (negative).")
