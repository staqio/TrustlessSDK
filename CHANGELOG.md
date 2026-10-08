# Changelog

## [1.2.0]

### Added

- Nusuk session exchange through `NusukProvider.exchangeNusukSession`, accepting an external ID token and returning either an established session or an OTP challenge. Complete the challenge with `confirmNusukSessionExchange`; both methods support async and callback APIs.
- Both exchange params take a `username`: the local key the session is stored under, never sent to the backend. Restore the session with `refreshSession(forUsername:)` and the same username; a different username gets `notLoggedIn`. A new session replaces the previous one, including its customer/KYC data.
- Automatic refresh of exchanged Nusuk sessions through `session/refresh`, replacing both access and refresh tokens with the returned pair.
- `confirmEnable2FARequest(phone:otp:options:)`, a password-less overload for sessions with no native credentials to send (e.g. Nusuk session-exchange) -- authenticates via the current access token and keeps the current session's username/origin, same as the existing params-based overload.

### Changed

- `ClientKeys.clientSecret` is optional and defaults to `nil`, for integrations with no secret, such as one that only uses Nusuk session exchange. Without it, the app-token, username/password login and user-token refresh requests on `tppa/token` are sent without the client `Authorization` header.
- The default `TrustlessDelegate.didSessionInvalidated()` no longer prints a message.
- Shared customer/KYC loading between legacy login and Nusuk session exchange, using the current access token before each request.
- `confirmEnable2FARequest` keeps the current session's origin, so an exchanged Nusuk session keeps refreshing through `session/refresh` after 2FA is enabled.

### Fixed

- Prevented a crash when legacy login receives an empty customer list.
- `confirmNusukSessionExchange` now sends `Scope` on `session/exchange/confirm`, the same single-string field every other 2FA/token request already sends -- the confirm call was missing it entirely.
- Stopped logging request headers and bodies, which exposed access/refresh tokens, the client secret, ID tokens, OTPs, passwords and user data. Request logging (method, path, status, duration) now runs in Debug builds only, and the remaining debug `print`s are removed.
- `confirmEnable2FARequest(params:options:)` no longer sends `Password` for an exchanged Nusuk session, which the backend rejected with "Invalid user credentials". Legacy sessions still send it.

## [1.1.0]

### Added

- Credit card application flow through `CreditCardsProvider`, including salary-data verification, eligibility assessment, previews, and request confirmation.
- `BillPaymentsProvider` for listing, creating, updating, validating, paying, and deleting bills.
- Beneficiary contact upload and beneficiary pagination through `BeneficiariesProvider`.
- Transfer support for CliQ payments, payment requests, billers, and transfer-purpose and currency dictionaries.
- Identity APIs for card-based password reset, username reminders, mobile-number changes, profile pictures, customer information, and user preferences.
- CliQ alias deletion.
- Public `userId`, `customerId`, and `kycId` properties on `TrustlessSDK`.
- Dedicated `notConnectedToInternet` and `networkConnectionLost` errors.

### Changed

- Updated transfer parameters and response models for domestic and international transfers, including expanded beneficiary details.
- Made client certificates optional; configure mTLS only when required by the backend.
- Switched card-limit updates to the v3 API with `SetCardLimitParams` and `setLimit`.
- Improved token refresh, session invalidation, request retry safety, and URL/form percent encoding.
- Added and refined project documentation, contribution guidance, ADRs, and release instructions.

### Fixed

- Corrected KYC meta-step decoding and credit-card eligibility required-document decoding.
- Made a salary slip optional when creating a credit-card preview.
- Omitted `TransferType` from CliQ transfer payloads.
- Preserved debug symbols when creating the XCFramework.

### Migration notes

- `AccountDetails` has been replaced by `Account` across `AccountsProvider`.
- Bill APIs moved from `TransfersProvider` to `BillPaymentsProvider`.
- Replace `CardsProvider.setLimits` and `SetCardSpendingLimitParams` with `setLimit` and `SetCardLimitParams`.
- Update transfer integrations for the revised parameter and response models; `createInternal` now accepts `CreateInternalTransferParams`, while CliQ creation returns `TransferDetails`.
- `TrustlessError.sessionExpired` was removed; handle session invalidation through the SDK delegate and server errors.
