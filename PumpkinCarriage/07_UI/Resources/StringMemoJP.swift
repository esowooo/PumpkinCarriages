// StringMemoJP.swift

// MARK: - RoleApplication (ra)
// Source: RoleApplication.swift
//
// RoleApplicationStatus.displayName
// "ra.status.approved" = "承認済み"
// "ra.status.rejected" = "却下"
// "ra.status.initial" = "初期状態"
// "ra.status.pending" = "審査中"
// "ra.status.archived" = "アーカイブ済み"
//
// RoleApplicationStatus.description
// "ra.statusDesc.approved" = "申請が承認されました。"
// "ra.statusDesc.rejected" = "申請は却下されました。"
// "ra.statusDesc.initial" = "申請はまだ提出されていません。"
// "ra.statusDesc.pending" = "申請は現在審査中です。"
// "ra.statusDesc.archived" = "アーカイブされています。"
//
// EvidenceReviewStatus.displayName
// "ra.evidence.verified" = "確認済み"
// "ra.evidence.submitted" = "提出済み"
// "ra.evidence.initial" = "初期状態"
// "ra.evidence.rejected" = "却下"



// MARK: - TermsVersion (tv)
// Source: TermsVersion.swift
//
// pk_vendor_activation_001 (vendorActivation)
// "tv.vendorActivation.001.c1" = "この掲載は情報提供のみを目的としており、別途合意がない限り、保証・提携・推薦を意味するものではありません。"
// "tv.vendorActivation.001.c2" = "提出された文章・ロゴ・画像（著作権・肖像権を含む）について、必要な権利・許可を有していることを確認します。"
// "tv.vendorActivation.001.c3" = "サービス運営の目的に限り、提供されたコンテンツの複製・表示・翻訳（日本語対応等）および最小限の編集（形式調整等）を許可します。"
// "tv.vendorActivation.001.c4" = "連絡先（メール・電話）を提供した場合、ログインユーザーに表示されることに同意します。業務用連絡先の使用を推奨します。"
// "tv.vendorActivation.001.c5" = "修正・非表示・取り下げはいつでも申請可能で、合理的な期間（例：7〜14日）以内に公開を停止します。"
// "tv.vendorActivation.001.c6" = "データはクラウドサービス（Google / Firebase 等）を通じて保存・処理され、インフラにより国外で処理される場合があります。"
// "tv.vendorActivation.001.c7" = "違法、不正確、第三者の権利を侵害する、またはポリシーに違反するコンテンツは非表示または却下される場合があります。"
//
// pk_vendor_hide_001 (vendorHide)
// "tv.vendorHide.001.c1" = "この操作により、ベンダーは顧客から非表示になります。"
// "tv.vendorHide.001.c2" = "ベンダーポータルから引き続き管理できます。"
// "tv.vendorHide.001.c3" = "再度表示するには、再申請して管理者の承認を受ける必要があります。"
//
// pk_vendor_archive_001 (vendorArchive)
// "tv.vendorArchive.001.c1" = "この操作により、ベンダーは公開停止となり、ポータル一覧から削除されます。"
// "tv.vendorArchive.001.c2" = "セキュリティ・コンプライアンス・バックアップの目的で、一部データは一定期間（最大30日など）保持される場合があります。"
// "tv.vendorArchive.001.c3" = "アーカイブ後の復元は制限される場合があります。必要な場合は速やかにサポートへ連絡してください。"



// MARK: - VendorStatusApplication (vsa)
// Source: VendorStatusApplication.swift
//
// VendorStatusApplicationEventType.displayName
// "vsa.event.submitted" = "提出済み"
// "vsa.event.resubmitted" = "再提出"
// "vsa.event.approved" = "承認"
// "vsa.event.rejected" = "却下"
// "vsa.event.statusApplied" = "ステータス適用済み"
//
// VendorStatusRequestType.displayName
// "vsa.request.activate" = "有効化"
// "vsa.request.hide" = "非表示"
// "vsa.request.archive" = "削除"
//
// VendorStatusDecision.displayName
// "vsa.decision.pending" = "保留中"
// "vsa.decision.approved" = "承認"
// "vsa.decision.rejected" = "却下"
//
// StatusRequestAction.title
// "vsa.action.apply.title" = "有効化を申請"
// "vsa.action.resubmit.title" = "再審査を申請"
// "vsa.action.hide.title" = "非表示を申請"
// "vsa.action.archive.title" = "削除を申請"
//
// StatusRequestAction.primaryButtonTitle
// "vsa.action.apply.primary" = "送信"
// "vsa.action.resubmit.primary" = "送信"
// "vsa.action.hide.primary" = "申請"
// "vsa.action.archive.primary" = "申請"



// MARK: - VendorSummary (vs)
// Source: VendorSummary.swift
//
// VendorSummary.placeholder
// "vs.placeholder.loading" = "読み込み中..."
//
// VendorStatus.displayName
// "vs.status.active" = "公開中"
// "vs.status.pending" = "審査中"
// "vs.status.hidden" = "非表示"
// "vs.status.rejected" = "却下"
// "vs.status.archived" = "アーカイブ済み"
//
// VendorStatus.uiDescription
// "vs.statusDesc.active" = "このベンダーは顧客に表示されています。"
// "vs.statusDesc.pending" = "申請は審査中です。現在は表示されていません。"
// "vs.statusDesc.rejected" = "申請が却下されました。内容を確認して再申請してください。"
// "vs.statusDesc.hidden" = "このベンダーは非表示です。"
// "vs.statusDesc.archived" = "このベンダーはアーカイブされています。"
//
// VendorCategory.displayName
// "vs.category.all" = "すべて"
// "vs.category.studio" = "スタジオ"
// "vs.category.dress" = "ドレス"
// "vs.category.hairMake" = "ヘア＆メイク"
// "vs.category.planner" = "プランナー"
// "vs.category.coupleSnap" = "スナップ"



// MARK: - ApplyVendorViewModel (avm)
// Source: ApplyVendorViewModel.swift
//
// primaryRegistrationButtonTitle
// "avm.primary.saveContinue" = "保存して続行"
// "avm.primary.updateContinue" = "更新して続行"
//
// statusSubtitle
// "avm.statusSubtitle.beforeStart" = "申請を開始するには、登録内容を保存してください。"
// "avm.statusSubtitle.initial" = "登録を完了し、証明書類を提出してください。"
// "avm.statusSubtitle.pending" = "提出内容を確認しています。"
// "avm.statusSubtitle.approved" = "承認されました。ベンダー機能をご利用いただけます。"
// "avm.statusSubtitle.rejected" = "却下理由を確認し、再提出してください。"
// "avm.statusSubtitle.archived" = "この申請はアーカイブされています。"
//
// rejectionSummary
// "avm.rejection.fallback" = "却下"
//
// errors
// "avm.error.requiredFields" = "必須項目を確認してください。"
// "avm.error.cannotEdit" = "現在のステータスでは編集できません。"
// "avm.error.saveFirst" = "先に登録情報を保存してください。"
// "avm.error.reviewEvidence" = "証明内容を確認してください。"
//
// success
// "avm.success.evidenceSubmitted" = "証明が送信されました。管理者の確認をお待ちください。"
//
// alert
// "avm.alert.defaultTitle" = "通知"



// MARK: - EditProfileViewModel (epvm)
// Source: EditProfileViewModel.swift
//
// alerts
// "epvm.alert.dupEmail.title" = "メールアドレスが重複しています"
// "epvm.alert.dupEmail.msg" = "このメールアドレスは既に使用されています。"
// "epvm.alert.dupUsername.title" = "ユーザー名が重複しています"
// "epvm.alert.dupUsername.msg" = "このユーザー名は既に使用されています。"
// "epvm.alert.error.title" = "エラー"
// "epvm.alert.missingBaseline.msg" = "ユーザー情報が見つかりません。画面を開き直してください。"
// "epvm.alert.userNotFound.msg" = "ユーザーが見つかりません。しばらくしてから再試行してください。"
// "epvm.alert.generic.msg" = "問題が発生しました。しばらくしてから再試行してください。"



// MARK: - LoginViewModel (lvm)
// Source: LoginViewModel.swift
//
// alerts
// "lvm.alert.invalidUsername.title" = "無効なユーザー名"
// "lvm.alert.invalidUsername.msg" = "ユーザー名を確認してください。"
// "lvm.alert.loginFailed.title" = "ログインに失敗しました"
// "lvm.alert.inactiveUser.msg" = "このアカウントは無効または停止されています。サポートにお問い合わせください。"
// "lvm.alert.invalidPassword.title" = "無効なパスワード"
// "lvm.alert.invalidPassword.msg" = "パスワードを確認してください。"
// "lvm.alert.invalidPassword.hintMsg" = "パスワードを確認してください。（前後に空白が含まれている可能性があります）"
// "lvm.alert.unexpected.msg" = "予期しないエラーが発生しました。"



// MARK: - RegisterView (rv)
// Source: RegisterView.swift
//
// labels & placeholders
// "rv.label.emailRequired" = "メールアドレス *"
// "rv.placeholder.email" = "メールアドレス"
// "rv.label.usernameRequired" = "ユーザー名 *"
// "rv.placeholder.username" = "ユーザー名"
// "rv.label.passwordRequired" = "パスワード *"
//
// buttons & texts
// "rv.button.submit" = "送信"
// "rv.text.haveAccount" = "既にアカウントをお持ちですか？"
// "rv.button.login" = "ログイン"
//
// toast
// "rv.toast.registerSuccess" = "登録が完了しました。"



// MARK: - RegisterReviewView (rrv)
// Source: RegisterReviewView.swift
//
// title
// "rrv.title.reviewDetails" = "入力内容の確認"
//
// fields
// "rrv.field.email" = "メールアドレス"
// "rrv.field.username" = "ユーザー名"
// "rrv.field.password" = "パスワード"
//
// buttons
// "rrv.button.edit" = "編集"
// "rrv.button.register" = "登録"


// MARK: - MainListViewModel (mlvm)
// Source: MainListViewModel.swift
//
// alerts
// "mlvm.alert.error.title" = "エラー"
// "mlvm.alert.loadFailed.msg" = "ベンダーの読み込みに失敗しました。もう一度お試しください。"



// MARK: - MainViewModel (mvm)
// Source: MainViewModel.swift
//
// alerts
// "mvm.alert.loadFailed.title" = "ベンダーの読み込みに失敗しました"
// "mvm.alert.loadFailed.msg" = "もう一度お試しください。"



// MARK: - MarkViewModel (mkvm)
// Source: MarkViewModel.swift
//
// alerts
// "mkvm.alert.loadFailed.title" = "ブックマークしたベンダーの読み込みに失敗しました"
// "mkvm.alert.loadFailed.msg" = "もう一度お試しください。"



// MARK: - ProfileViewModel (pvm)
// Source: ProfileViewModel.swift
//
// messages
// "pvm.message.error.title" = "エラー"
// "pvm.message.loginFirst.msg" = "先にログインしてください。"



// MARK: - ReauthViewModel (rvm)
// Source: ReauthViewModel.swift
//
// alerts
// "rvm.alert.invalidUsername.title" = "無効なユーザー名"
// "rvm.alert.invalidUsername.msg" = "ユーザー名を確認してください。"
// "rvm.alert.loginFailed.title" = "ログインに失敗しました"
// "rvm.alert.inactiveUser.msg" = "このアカウントは無効または停止されています。サポートにお問い合わせください。"
// "rvm.alert.invalidPassword.title" = "無効なパスワード"
// "rvm.alert.invalidPassword.msg" = "パスワードを確認してください。"
// "rvm.alert.invalidPassword.hintMsg" = "パスワードを確認してください。（前後に空白が含まれている可能性があります）"
// "rvm.alert.unexpected.msg" = "予期しないエラーが発生しました。"



// MARK: - RegisterViewModel (regvm)
// Source: RegisterViewModel.swift
//
// alerts
// "regvm.alert.dupEmail.title" = "このメールアドレスは既に使用されています"
// "regvm.alert.dupEmail.msg" = "別のメールアドレスを使用してください。"
// "regvm.alert.dupUsername.title" = "このユーザー名は既に使用されています"
// "regvm.alert.dupUsername.msg" = "別のユーザー名を使用してください。"
// "regvm.alert.registerFailed.title" = "登録に失敗しました"
// "regvm.alert.createMarkFailed.title" = "マークの作成に失敗しました"
// "regvm.alert.unexpected.msg" = "予期しないエラーが発生しました。"



// MARK: - VendorDetailViewModel (vdvm)
// Source: VendorDetailViewModel.swift
//
// messages
// "vdvm.message.warning.title" = "警告"
// "vdvm.message.refreshSummaryFailed.msg" = "ベンダー概要の更新に失敗しました。"
// "vdvm.message.loadDetailFailed.msg" = "ベンダー詳細の読み込みに失敗しました。"
// "vdvm.message.loadImagesFailed.msg" = "ベンダー画像の読み込みに失敗しました。"
// "vdvm.message.updateBookmarkFailed.msg" = "ブックマークの更新に失敗しました。"
// "vdvm.message.updateBookmarkCountFailed.msg" = "ブックマーク数の更新に失敗しました。"
//
// alerts
// "vdvm.alert.error.title" = "エラー"
// "vdvm.alert.signInToUseBookmarks.msg" = "ブックマーク機能を利用するにはログインしてください。"



// MARK: - LoginView (lv)
// Source: LoginView.swift
//
// labels & placeholders
// "lv.label.username" = "ユーザー名"
// "lv.placeholder.username" = "username"
// "lv.label.password" = "パスワード"
//
// buttons
// "lv.button.login" = "ログイン"
// "lv.button.signUp" = "新規登録"
// "lv.button.guestLogin" = "ゲストとしてログイン"
// "lv.button.ok" = "OK"
//
// texts
// "lv.text.noAccount" = "アカウントをお持ちでないですか？"
//
// toast
// "lv.toast.signInSuccess" = "ログインしました。"



// MARK: - MainListView (mlv)
// Source: MainListView.swift
//
// filter
// "mlv.filter.label" = "フィルター"
// "mlv.filter.reset" = "リセット"
// "mlv.filter.allVendors" = "すべてのベンダー"
//
// order
// "mlv.order.label" = "並び順"
// "mlv.order.nameAsc" = "名前（A–Z）"
// "mlv.order.nameDesc" = "名前（Z–A）"
// "mlv.order.mostMarked" = "ブックマーク数が多い順"
//
// search
// "mlv.search.prompt" = "検索"



// MARK: - MainView (mv)
// Source: MainView.swift
//
// sections
// "mv.section.category" = "カテゴリ"
// "mv.section.popularStores" = "人気の店舗"



// MARK: - MarkView (mkv)
// Source: MarkView.swift
//
// texts
// "mkv.text.signInToUseMarks" = "マーク機能を利用するにはログインしてください。"
// "mkv.text.noMarkFound" = "マークはありません"
// "mkv.text.signInAgainIfIncorrect" = "表示に問題がある場合は、再度ログインしてください。"
//
// alerts
// "mkv.alert.signInRequired.title" = "ログインが必要です"
//
// buttons
// "mkv.button.ok" = "OK"



// MARK: - ApplyVendorView (av)
// Source: ApplyVendorView.swift
//
// toast
// "av.toast.completeRegistrationFirst" = "先に登録を完了してください。"
// "av.toast.copied" = "コピーしました。"
//
// common
// "av.button.ok" = "OK"
// "av.text.waitUntilReviewed" = "申請の審査が完了するまでお待ちください。"
// "av.tab.registration" = "登録"
// "av.tab.evidence" = "証明"
// "av.status.format" = "ステータス：%@"
// "av.rejectionReason.title" = "却下理由"
//
// sections
// "av.section.applicant" = "申請者"
// "av.section.businessOptional" = "事業情報（任意）"
// "av.section.confirmations" = "確認事項"
// "av.section.messageToAdminOptional" = "管理者へのメッセージ（任意）"
//
// fields
// "av.field.name" = "氏名"
// "av.field.role" = "役職"
// "av.field.email" = "メールアドレス"
// "av.field.phone" = "電話番号"
// "av.field.business" = "事業名"
// "av.field.category" = "カテゴリ"
//
// placeholders
// "av.placeholder.applicantNameRequired" = "申請者名（必須）"
// "av.placeholder.roleTitleRequired" = "役職（必須）"
// "av.placeholder.emailOptional" = "メールアドレス（任意）"
// "av.placeholder.phoneOptional" = "電話番号（任意）"
// "av.placeholder.brandName" = "ブランド名／事業名"
// "av.placeholder.vendorCategoryExample" = "ベンダーカテゴリ（例：スタジオ、ドレス、ヘア＆メイクなど）"
// "av.placeholder.additionalMessage" = "追加メッセージ"
//
// checkboxes
// "av.checkbox.authority" = "この事業を代表する権限を有しています"
// "av.checkbox.rights" = "アップロードした素材について必要な権利（著作権・肖像権等）を取得しています"
//
// confirmed
// "av.confirmed.format" = "確認済み：%@"
//
// evidence
// "av.evi.text.completeRegistrationTabFirst" = "先に「登録」タブを完了してください。"
// "av.evi.text.underReviewCannotEdit" = "現在審査中のため、証明内容は編集できません。"
// "av.evi.section.verificationMethod" = "認証方法"
// "av.evi.method.officialEmail" = "公式メール"
// "av.evi.method.verificationCode" = "認証コード"
// "av.evi.step1.inputFields" = "ステップ1：入力"
// "av.evi.step2.sendEmail" = "ステップ2：メール送信"
// "av.evi.step2.postCode" = "ステップ2：コード投稿"
// "av.evi.step3.submit" = "ステップ3：送信"
//
// bullets
// "av.evi.bullet.useOfficialEmail" = "・公式サイト等に掲載されているメールアドレスを使用してください。"
// "av.evi.bullet.sendToBelowAddress" = "・ステップ1で入力したメールから、下記アドレスへ送信してください。"
// "av.evi.bullet.copyEmailTitle" = "・メール件名は以下をコピーしてください。"
// "av.evi.bullet.noEmailBodyNeeded" = "・本文の入力は不要です。"
// "av.evi.bullet.urlWhereCodePosted" = "・URL：認証コードを掲載したURLを入力してください。"
// "av.evi.bullet.detailWhereCodePosted" = "・詳細：コードを掲載した場所（例：ストーリー、プロフィール等）を具体的に記載してください。"
// "av.evi.bullet.postCodeThenSubmit" = "・公式チャンネルにコードを掲載後、送信してください。"
// "av.evi.bullet.channelsExample" = "・チャンネル例：Webサイト、Instagram、YouTube、X 等"
// "av.evi.bullet.removeAfterApproved" = "・承認後、認証コードは削除して構いません。"
//
// evidence misc
// "av.evi.text.contactIfNoMethod" = "どの方法も利用できない場合は、お問い合わせください。現在他の方法を検討中です。"
// "av.evi.field.url" = "URL"
// "av.evi.field.detail" = "詳細"
// "av.evi.placeholder.emailHintExample" = "pumpkin@*example.com*"
// "av.evi.placeholder.emailLink" = "メールが掲載されているリンク"
// "av.evi.placeholder.channelUrl" = "コード掲載先URL"
// "av.evi.placeholder.channelDetail" = "コードの掲載場所を簡潔に説明してください"
// "av.evi.label.emailTo" = "送信先メール"
// "av.evi.value.contactEmail" = "contact@*example.com*"
// "av.evi.label.emailTitle" = "メール件名"
// "av.evi.emailTitle.format" = "[RoleApplication][Email] User:%@ Code:%@"
// "av.evi.label.verificationCode" = "認証コード"
// "av.evi.button.submitEvidence" = "証明を送信"



// MARK: - ApplyCurtainView (avc)
// Source: ApplyVendorView.swift
//
// title & text
// "avc.title.becomeVendor" = "ベンダーになる"
// "avc.text.subtitle" = "登録を完了し、1つ以上の証明方法を提出して公式チャンネルを確認します。"
//
// steps
// "avc.step.registration.title" = "登録"
// "avc.step.registration.detail" = "役割・事業の基本情報"
// "avc.step.evidence.title" = "証明"
// "avc.step.evidence.detail" = "公式メールまたは認証コード"
// "avc.step.submit.title" = "提出"
// "avc.step.submit.detail" = "確認後に通知します"
//
// buttons
// "avc.button.startApplication" = "申請を開始"
// "avc.button.notNow" = "後で"
//
// navigation
// "avc.nav.vendorApplication" = "ベンダー申請"



// MARK: - EditProfileView (epv)
// Source: EditProfileView.swift
//
// title
// "epv.title.editProfile" = "プロフィール編集"
//
// labels & placeholders
// "epv.label.email" = "メールアドレス"
// "epv.placeholder.email" = "メールアドレス"
// "epv.label.username" = "ユーザー名"
// "epv.placeholder.username" = "ユーザー名"
// "epv.label.password" = "パスワード"
//
// buttons
// "epv.button.save" = "保存"
// "epv.button.ok" = "OK"
//
// discard alert
// "epv.discard.title" = "変更を破棄しますか？"
// "epv.discard.message" = "未保存の変更があります。"
// "epv.discard.discard" = "破棄"
// "epv.discard.cancel" = "キャンセル"


// MARK: - FAQView (faqv)
// Source: FAQView.swift
//
// title
// "faqv.title.faqs" = "よくある質問"
//
// categories
// "faqv.category.account" = "アカウント"
// "faqv.category.vendor" = "ベンダー"
// "faqv.category.app" = "アプリ"
// "faqv.category.privacy" = "プライバシー"
// "faqv.category.other" = "その他"
//
// questions
// "faqv.q.account.delete.title" = "アカウントを削除するには？"
// "faqv.q.account.delete.body" = "アカウントを完全に削除するには、プロフィールメニューの「お問い合わせ」からご連絡ください。"
// "faqv.q.account.changeUsername.title" = "ユーザー名は変更できますか？"
// "faqv.q.account.changeUsername.body" = "ユーザー名を変更するには、プロフィールメニューのプロフィール更新機能をご利用ください。"
// "faqv.q.account.changePassword.title" = "パスワードは変更できますか？"
// "faqv.q.account.changePassword.body" = "パスワードを変更するには、プロフィールメニューのプロフィール更新機能をご利用ください。"
// "faqv.q.vendor.contactVendor.title" = "ベンダーに連絡できますか？"
// "faqv.q.vendor.contactVendor.body" = "ベンダーへ直接連絡できる機能を開発中です。続報をお待ちください。"
// "faqv.q.vendor.products.title" = "ベンダーの提供内容は何ですか？"
// "faqv.q.vendor.products.body" = "提供内容（商品・プラン等）の掲載に向けて、ベンダーと調整中です。続報をお待ちください。"
// "faqv.q.vendor.purpose.title" = "スタジオ・ドレス・ヘア&メイクの役割は？"
// "faqv.q.vendor.purpose.body" = "前撮りでは、スタジオは撮影（フォトグラファー）、ドレスは撮影用ドレスのレンタル、ヘア&メイクは撮影準備のスタイリングを担当します。"
// "faqv.q.app.notifications.title" = "通知は設定できますか？"
// "faqv.q.app.notifications.body" = "現在、通知機能はありません。開発をお待ちください。"
// "faqv.q.app.deleteInfo.title" = "アプリを削除すれば情報も削除されますか？"
// "faqv.q.app.deleteInfo.body" = "アプリ削除だけでは情報が削除されない場合があります。プロフィールメニューの「お問い合わせ」からご連絡ください。"


// MARK: - NotificationsView (nv)
// Source: NotificationsView.swift
//
// title
// "nv.title.notifications" = "お知らせ"
//
// categories
// "nv.category.info" = "【お知らせ】"
// "nv.category.warning" = "【注意】"
// "nv.category.error" = "【エラー】"
// "nv.category.maintenance" = "【メンテナンス】"
//
// mock notifications
// "nv.mock.1.title" = "iOSアップデートについて"
// "nv.mock.1.body" = "TEST Content. TEST Content TEST Content. TEST Content TEST Content TEST Content TEST Content... TEST Content.TEST Content.TEST Content.TEST Content."
// "nv.mock.2.title" = "不審な電話にご注意ください"
// "nv.mock.2.body" = "TEST Content. TEST Content TEST Content. TEST Content TEST Content TEST Content TEST Content... TEST Content.TEST Content.TEST Content.TEST Content."
// "nv.mock.3.title" = "2025.01.01にメンテナンス予定"
// "nv.mock.3.body" = "TEST Content. TEST Content TEST Content. TEST Content TEST Content TEST Content TEST Content... TEST Content.TEST Content.TEST Content.TEST Content."
// "nv.mock.4.title" = "2025.03.01にメンテナンス予定"
// "nv.mock.4.body" = "TEST Content. TEST Content TEST Content. TEST Content TEST Content TEST Content TEST Content... TEST Content.TEST Content.TEST Content.TEST Content."
// "nv.mock.5.title" = "iOSアップデートについて"
// "nv.mock.5.body" = "TEST Content. TEST Content TEST Content. TEST Content TEST Content TEST Content TEST Content... TEST Content.TEST Content.TEST Content.TEST Content."


// MARK: - ProfileView (pv)
// Source: ProfileView.swift
//
// sections
// "pv.section.general" = "一般"
// "pv.section.help" = "ヘルプ"
// "pv.section.vendorMenu" = "ベンダーメニュー"
// "pv.section.adminMenu" = "管理者メニュー"
//
// buttons
// "pv.button.setting" = "設定"
// "pv.button.notifications" = "お知らせ"
// "pv.button.faq" = "FAQ"
// "pv.button.inquiry" = "お問い合わせ"
// "pv.button.signOut" = "ログアウト"
// "pv.button.signInSignUp" = "ログイン／新規登録"
// "pv.button.cancel" = "キャンセル"
// "pv.button.ok" = "OK"
// "pv.button.vendorPortal" = "ベンダーポータル"
// "pv.button.applyVendor" = "ベンダー申請"
// "pv.button.adminPortal" = "管理者ポータル"
//
// alerts
// "pv.alert.signOut.title" = "ログアウト"
// "pv.alert.signOut.msg" = "ログアウトしますか？"
//
// mail
// "pv.mail.unavailable.title" = "メールアプリにアクセスできません"
// "pv.mail.unavailable.msg" = "メールアプリにサインインしてから、もう一度お試しください。"
// "pv.inquiry.subject.guest" = "[Guest] お問い合わせ"
// "pv.inquiry.subject.normal" = "お問い合わせ"
// "pv.inquiry.body" = "サポートのため、できるだけ詳しくご記入ください。"
//
// user fallbacks
// "pv.user.guest" = "ゲスト"
// "pv.user.default" = "Mr. Pumpkin"
//
// messages
// "pv.message.accessDenied.title" = "アクセスが拒否されました"
// "pv.message.accessDenied.vendorOrAdmin.msg" = "ベンダー／管理者アカウントでログインしてください。"
// "pv.message.accessDenied.admin.msg" = "管理者アカウントでログインしてください。"
// "pv.message.notSignedIn.title" = "未ログイン"
// "pv.message.notSignedIn.msg" = "アクセスするにはログインしてください。"
// "pv.message.loginFailed.title" = "ログインに失敗しました"
// "pv.message.loginFailed.differentUser.msg" = "現在ログイン中のアカウントでログインしてください。"
// "pv.message.loginFailed.tryAgain.msg" = "もう一度お試しください。"


// MARK: - ReauthView (reav)
// Source: ReauthView.swift
//
// labels & placeholders
// "reav.label.username" = "ユーザー名"
// "reav.placeholder.username" = "username"
// "reav.label.password" = "パスワード"
//
// buttons
// "reav.button.login" = "ログイン"
// "reav.button.ok" = "OK"
//
// texts
// "reav.text.loginAgainToProceed" = "続行するには再度ログインしてください"
//
// toast
// "reav.toast.signInAgain" = "再度ログインしてください。"
// "reav.toast.loginFailed" = "ログインに失敗しました。ユーザー名とパスワードを確認してください。"
// "reav.toast.confirmSuccess" = "確認ログインが完了しました。"
// "reav.toast.useCurrentAccount" = "現在ログイン中のアカウントでログインしてください。"


// MARK: - VendorDetailView (vdv)
// Source: VendorDetailView.swift
//
// share
// "vdv.share.checkOutVendor" = "PumpkinCarriageでこのベンダーをチェック。"
//
// alerts
// "vdv.alert.openExternal.title" = "外部リンクを開きますか？"
//
// buttons
// "vdv.button.open" = "開く"
// "vdv.button.cancel" = "キャンセル"
// "vdv.button.ok" = "OK"


// MARK: - VendorManageViewModel (vmanvm)
// Source: VendorManageViewModel.swift
//
// alerts
// "vmanvm.alert.permissionDenied.title" = "権限がありません"
// "vmanvm.alert.permissionDenied.msg" = "ベンダーアカウントのみがベンダーを管理できます。ベンダーアカウントでログインして再試行してください。"
// "vmanvm.alert.error.title" = "エラー"
// "vmanvm.alert.accessConfirmFailed.msg" = "アクセス確認中に問題が発生しました。しばらくしてから再試行してください。"
// "vmanvm.alert.loadFailed.title" = "ベンダーの読み込みに失敗しました"
// "vmanvm.alert.tryAgain.msg" = "もう一度お試しください。"


// MARK: - VendorReviewViewModel (vrvm)
// Source: VendorReviewViewModel.swift
//
// messages
// "vrvm.message.warning.title" = "警告"
// "vrvm.message.refreshSummaryFailed.msg" = "ベンダー概要の更新に失敗しました。"
// "vrvm.message.loadDetailFailed.msg" = "ベンダー詳細の読み込みに失敗しました。"
// "vrvm.message.loadImagesFailed.msg" = "ベンダー画像の読み込みに失敗しました。"


// MARK: - VendorStatusViewModel (vsvm)
// Source: VendorStatusViewModel.swift
//
// success
// "vsvm.success.requestReceived" = "申請を受け付けました。"
//
// alerts
// "vsvm.alert.permissionDenied.title" = "権限がありません"
// "vsvm.alert.permissionDenied.msg" = "ベンダーのみアクセスできます。ログインして再試行してください。"
// "vsvm.alert.error.title" = "エラー"
// "vsvm.alert.userContextMissing.msg" = "ユーザー情報がありません。再度ログインしてください。"
// "vsvm.alert.warning.title" = "警告"
// "vsvm.alert.refreshSummaryFailed.msg" = "ベンダー概要の更新に失敗しました。"
// "vsvm.alert.loadDetailFailed.msg" = "ベンダー詳細の読み込みに失敗しました。"
// "vsvm.alert.duplicatePending.title" = "申請が既に存在します"
// "vsvm.alert.duplicatePending.msg" = "前の申請が処理されるまでお待ちください。"
// "vsvm.alert.saveFailed.title" = "保存に失敗しました"
// "vsvm.alert.saveFailed.userContextMissing.msg" = "ステータス申請は送信されましたが、ユーザー情報がありません。もう一度お試しください。"
// "vsvm.alert.saveFailed.updateStatusFailed.msg" = "ステータス申請は送信されましたが、ベンダーステータスの更新に失敗しました。もう一度お試しください。"
// "vsvm.alert.statusAppNotFound.msg" = "ステータス申請が見つかりません。"
// "vsvm.alert.submitFailed.msg" = "申請の送信に失敗しました。"


// MARK: - VendorUpdateViewModel (vuvm)
// Source: VendorUpdateViewModel.swift
//
// alerts
// "vuvm.alert.permissionDenied.title" = "権限がありません"
// "vuvm.alert.permissionDenied.msg" = "ベンダーアカウントのみがベンダーを登録・管理できます。ベンダーアカウントでログインして再試行してください。"
// "vuvm.alert.loginAgain.msg" = "再度ログインしてください。"
// "vuvm.alert.error.title" = "エラー"
// "vuvm.alert.vendorNotFound.msg" = "ベンダーが見つからないか、アクセス権がありません。"
// "vuvm.alert.vendorDetailNotFound.msg" = "ベンダー詳細が見つかりません。しばらくしてから再試行してください。"
// "vuvm.alert.loadVendorFailed.msg" = "ベンダーの読み込みに失敗しました。しばらくしてから再試行してください。"
// "vuvm.alert.updateNotAllowed.title" = "更新できません"
// "vuvm.alert.updateNotAllowed.msg" = "現在のステータスでは変更できません。"
// "vuvm.alert.invalidLinkType.title" = "無効なリンク種別"
// "vuvm.alert.invalidLinkType.msg" = "先にリンク種別を選択してください。"
// "vuvm.alert.imageLimit.title" = "画像の上限に達しました"
// "vuvm.alert.imageLimit.format" = "最大%d枚までアップロードできます。"
// "vuvm.alert.noChanges.title" = "変更はありません"
// "vuvm.alert.noChanges.msg" = "更新する内容がありません。"
// "vuvm.alert.sessionInvalid.msg" = "セッションが無効です。再度ログインしてください。"
// "vuvm.alert.tryAgain.msg" = "もう一度お試しください。"
//
// validation
// "vuvm.validation.storeName.invalid.title" = "無効な店舗名"
// "vuvm.validation.storeName.invalid.msg" = "店舗名を入力してください。"
// "vuvm.validation.category.invalid.title" = "無効なカテゴリ"
// "vuvm.validation.category.invalid.msg" = "正しいカテゴリを選択してください。"
// "vuvm.validation.country.invalid.title" = "無効な国"
// "vuvm.validation.country.invalid.msg" = "国を選択してください。"
// "vuvm.validation.city.invalid.title" = "無効な市"
// "vuvm.validation.city.invalid.msg" = "市を選択してください。"
// "vuvm.validation.district.invalid.title" = "無効な地区"
// "vuvm.validation.district.invalid.msg" = "地区を入力してください。"
// "vuvm.validation.address.invalid.title" = "無効な住所詳細"
// "vuvm.validation.address.invalid.msg" = "通り名または建物名を1つ以上入力してください。"
// "vuvm.validation.language.required.title" = "言語の選択が必要です"
// "vuvm.validation.language.required.msg" = "対応言語を1つ以上選択してください。"
// "vuvm.validation.description.required.title" = "説明が必要です"
// "vuvm.validation.description.required.msg" = "日本語の説明は必須です。"
// "vuvm.validation.description.tooShort.title" = "説明が短すぎます"
// "vuvm.validation.description.tooShort.msg" = "日本語の説明は10文字以上入力してください。"
//
// success
// "vuvm.success.updated.title" = "ベンダーを更新しました"
// "vuvm.success.registered.title" = "ベンダーを登録しました"
// "vuvm.success.registered.msg" = "「ベンダー管理」メニューで確認してください。"


// MARK: - StatusApplicationView (sav)
// Source: StatusApplicationView.swift
//
// alerts
// "sav.alert.cancel" = "キャンセル"
// "sav.alert.confirm" = "確認"
//
// buttons
// "sav.button.close" = "閉じる"
//
// confirmations
// "sav.confirm.hide.format" = "『%@』を非表示にしますか？"
// "sav.confirm.delete.format" = "『%@』を削除しますか？"
//
// vendor
// "sav.vendorId.format" = "ベンダーID：%@"
//
// terms
// "sav.card.termsAgreement" = "利用規約・同意"
// "sav.terms.notAvailable" = "利用規約を表示できません。"
// "sav.consent.agreeProceed" = "上記を理解し、同意して進みます。"
// "sav.consent.archiveAgree" = "公開停止となり、データ削除に時間がかかる可能性があることを理解します。"
//
// notes
// "sav.notes.titleOptional" = "メモ（任意）"
// "sav.notes.placeholder" = "審査担当者へのメモ（任意）"
//
// hint
// "sav.hint.submitEnabled" = "利用規約に同意すると送信／申請が有効になります。"


// MARK: - VendorGuideView (vgv)
// Source: VendorGuideView.swift
//
// title
// "vgv.title.guideToManagingVendors" = "ベンダー管理ガイド"
//
// categories
// "vgv.category.register" = "ベンダー登録"
// "vgv.category.reviewEdit" = "登録済みベンダーの確認／編集"
// "vgv.category.changeStatus" = "ベンダーステータスの変更"
//
// guides
// "vgv.guide.register.01" = "「ベンダー登録」メニューを選択します。"
// "vgv.guide.register.02" = "必須項目をすべて入力します。"
// "vgv.guide.register.03" = "「送信」ボタンを押します。"
// "vgv.guide.register.04" = "問題がなければ、成功アラートが表示されます。"
// "vgv.guide.reviewEdit.01" = "「ベンダー管理」メニューを選択します。"
// "vgv.guide.reviewEdit.02" = "一覧上部のベンダーをタップすると、登録したベンダーの詳細を確認できます。"
// "vgv.guide.reviewEdit.03" = "詳細画面で「編集」ボタンを押すと、情報を変更できます。"
// "vgv.guide.reviewEdit.04" = "編集画面で必要な項目を修正します。"
// "vgv.guide.reviewEdit.05" = "「変更を保存」ボタンで修正内容を保存します。"
// "vgv.guide.changeStatus.01" = "「ベンダー管理」メニューを選択します。"
// "vgv.guide.changeStatus.02" = "「ステータス」スイッチを切り替えてステータスを変更します。"
// "vgv.guide.changeStatus.03" = "変更時にアラートが表示されるので、「OK」をタップして続行します。"
// "vgv.guide.changeStatus.04" = "確認後、ベンダーは「公開中」に変更され、顧客に表示されます。"


// MARK: - VendorManageView (vmv)
// Source: VendorManageView.swift
//
// title
// "vmv.title.myVendors" = "自分のベンダー"
//
// texts
// "vmv.text.noManagedVendors" = "まだ管理しているベンダーはありません。"
//
// buttons
// "vmv.button.ok" = "OK"


// MARK: - VendorPortalView (vpv)
// Source: VendorPortalView.swift
//
// title
// "vpv.title.vendorPortal" = "ベンダーポータル"
//
// sections
// "vpv.section.accountInfo" = "アカウント情報"
//
// user
// "vpv.user.format" = "ユーザー：%@"
//
// texts
// "vpv.text.manageVendorsHere" = "ここからベンダーを管理できます。"
//
// actions
// "vpv.action.register.title" = "ベンダー登録"
// "vpv.action.register.subtitle" = "新しいベンダープロフィールを作成"
// "vpv.action.manage.title" = "ベンダー管理"
// "vpv.action.manage.subtitle" = "店舗情報を編集"
// "vpv.action.guide.title" = "ベンダーガイド"
// "vpv.action.guide.subtitle" = "ベンダー機能の使い方"


// MARK: - VendorReviewView (vrv)
// Source: VendorReviewView.swift
//
// buttons
// "vrv.button.edit" = "編集"
// "vrv.button.open" = "開く"
// "vrv.button.cancel" = "キャンセル"
//
// alerts
// "vrv.alert.openExternal.title" = "外部リンクを開きますか？"


// MARK: - VendorStatusView (vsv)
// Source: VendorStatusView.swift
//
// title
// "vsv.title.status" = "ステータス"
//
// buttons
// "vsv.button.ok" = "OK"
//
// sections
// "vsv.section.timeline" = "タイムライン"
// "vsv.section.actions" = "操作"
//
// timeline labels
// "vsv.timeline.created" = "作成"
// "vsv.timeline.updated" = "更新"
// "vsv.timeline.vendorId" = "ベンダーID"
//
// actions
// "vsv.action.underReview" = "審査中"
// "vsv.action.applyActivation" = "有効化を申請"
// "vsv.action.resubmitReview" = "再審査を申請"
// "vsv.action.edit" = "編集"
// "vsv.action.requestHide" = "非表示を申請"
// "vsv.action.requestDelete" = "削除を申請"
// "vsv.action.contactSupport" = "サポートに連絡"
//
// rejection summary
// "vsv.reject.title" = "却下概要"
// "vsv.reject.reason" = "理由"
// "vsv.reject.reasonBody" = "有効化の前に内容の修正が必要です。"
// "vsv.reject.notes" = "メモ"
// "vsv.reject.notesBody" = "ベンダー情報を更新し、再審査を申請してください。"
//
// requirements
// "vsv.requirements.title" = "有効化条件"
// "vsv.requirements.image" = "画像を1枚以上"
// "vsv.requirements.contact" = "連絡先（メールまたは電話）"
// "vsv.requirements.description" = "説明の入力"
// "vsv.requirements.terms" = "利用規約に同意"


// MARK: - VendorUpdateView (vuv)
// Source: VendorUpdateView.swift
//
// navigation
// "vuv.nav.back" = "戻る"
//
// titles
// "vuv.title.register" = "ベンダー登録"
// "vuv.title.update" = "ベンダー更新"
//
// submit
// "vuv.submit.submitting" = "送信中..."
// "vuv.submit.saving" = "保存中..."
// "vuv.submit.submit" = "送信"
// "vuv.submit.saveChanges" = "変更を保存"
//
// discard
// "vuv.discard.title" = "変更を破棄しますか？"
// "vuv.discard.keepEditing" = "編集を続ける"
// "vuv.discard.discard" = "破棄"
// "vuv.discard.message" = "未保存の変更があります。戻ると編集内容は失われます。"
//
// update confirm
// "vuv.updateConfirm.title" = "ベンダーを更新しますか？"
// "vuv.updateConfirm.message" = "承認されるまで顧客には非表示になります（ステータス変更申請が必要です）。"
//
// common buttons
// "vuv.button.ok" = "OK"
// "vuv.button.cancel" = "キャンセル"
// "vuv.button.confirm" = "確認"
// "vuv.button.add" = "追加"
// "vuv.button.remove" = "削除"
//
// sections
// "vuv.section.basicInfo" = "基本情報"
// "vuv.section.location" = "場所"
// "vuv.section.languages" = "言語"
// "vuv.section.description" = "説明"
// "vuv.section.contactOptional" = "連絡先（任意）"
// "vuv.section.externalLinkOptional" = "外部リンク（任意）"
// "vuv.section.imagesOptional" = "画像（任意）"
//
// fields
// "vuv.field.name" = "名前"
// "vuv.field.category" = "カテゴリ"
// "vuv.field.country" = "国"
// "vuv.field.city" = "市"
// "vuv.field.district" = "地区"
// "vuv.field.districtOther" = "地区（その他）"
// "vuv.field.street" = "住所"
// "vuv.field.email" = "メールアドレス"
// "vuv.field.phone" = "電話番号"
// "vuv.field.linkType" = "種別"
//
// placeholders
// "vuv.placeholder.vendorNameEng" = "ベンダー名（英）"
// "vuv.placeholder.email" = "メールアドレス"
// "vuv.placeholder.phone" = "電話番号"
// "vuv.placeholder.linkDetails" = "詳細"
// "vuv.placeholder.districtEng" = "地区を入力（英）"
// "vuv.placeholder.streetEng" = "住所詳細（英）"
// "vuv.placeholder.loading" = "読み込み中"
//
// notices
// "vuv.notice.title" = "通知"
// "vuv.notice.body" = "ベンダー詳細を更新すると、管理者の承認まで顧客には非表示になります。更新後、ステータス審査を再申請してください。"
// "vuv.notice.englishRequired" = "* 名前、地区（その他）、住所は英語で入力してください。"
//
// district
// "vuv.district.manualInput.format" = "%@（手入力）"
//
// links
// "vuv.link.other" = "その他"
//
// images
// "vuv.images.none" = "（画像なし）"
// "vuv.images.main" = "メイン"
// "vuv.images.thumbnailHint" = "が一覧のサムネイルとして表示されます。"
// "vuv.images.remove.title" = "画像を削除しますか？"
// "vuv.images.remove.msg" = "この操作は取り消せません。"
// "vuv.images.mainLabel" = "メイン"
// "vuv.images.setMain" = "メインに設定"
//
// drag
// "vuv.drag.move" = "移動"


// MARK: - AdminPortalViewModel (apvm)
// Source: AdminPortalViewModel.swift
//
// alerts
// "apvm.alert.permissionDenied.title" = "権限がありません"
// "apvm.alert.permissionDenied.msg" = "管理者のみアクセスできます。管理者アカウントでログインして再試行してください。"


// MARK: - AdminRoleDetailViewModel (ardvm)
// Source: AdminRoleDetailViewModel.swift
//
// templates
// "ardvm.tpl.ownershipAuthority.title" = "所有・権限の証明が不十分です"
// "ardvm.tpl.ownershipAuthority.text" = "この事業を代表する権限があることを確認できませんでした。"
// "ardvm.tpl.ownershipChannel.title" = "公式チャンネルを確認できません"
// "ardvm.tpl.ownershipChannel.text" = "提出された証明から、公式チャンネルの所有を確認できませんでした。"
// "ardvm.tpl.identityUnclear.title" = "申請者の本人確認が不十分です"
// "ardvm.tpl.identityUnclear.text" = "申請者が事業代表者と一致することを確認できませんでした。"
// "ardvm.tpl.policyIssue.title" = "ポリシーに関する問題"
// "ardvm.tpl.policyIssue.text" = "申請内容がプラットフォームポリシーの要件を満たしていません。"
// "ardvm.tpl.other.title" = "その他"
// "ardvm.tpl.other.text" = "現時点では申請を承認できませんでした。"
//
// alerts
// "ardvm.alert.error.title" = "エラー"
// "ardvm.alert.appNotFound.msg" = "申請が見つかりません。"
// "ardvm.alert.notAllowed.title" = "許可されていません"
// "ardvm.alert.notAllowed.statusNotUpdatable.msg" = "この申請は更新できないステータスです。"
// "ardvm.alert.notAllowed.notActionable.msg" = "この申請は操作できません。"
// "ardvm.alert.missingConfirmations.title" = "確認事項が不足しています"
// "ardvm.alert.missingConfirmations.msg" = "申請者の確認事項が未完了です。"
// "ardvm.alert.missingEvidence.title" = "証明がありません"
// "ardvm.alert.missingEvidence.msg" = "証明が提出されていません。"
// "ardvm.alert.evidenceNotVerified.title" = "証明が未確認です"
// "ardvm.alert.evidenceNotVerified.msg" = "承認するには、すべての証明項目を確認済みにする必要があります。"
// "ardvm.alert.approvedButRoleUpdateFailed.msg" = "承認しましたが、ユーザー権限の更新に失敗しました。再試行してください。"
// "ardvm.alert.missingTemplate.title" = "テンプレートが未選択です"
// "ardvm.alert.missingTemplate.msg" = "却下テンプレートを選択してください。"
// "ardvm.alert.evidenceNotFound.msg" = "証明が見つかりません。"
// "ardvm.alert.adminPermissionRequired.msg" = "管理者権限が必要です。"
// "ardvm.alert.invalidSession.title" = "セッションが無効です"
// "ardvm.alert.invalidSession.msg" = "審査には認証が必要です。"


// MARK: - AdminRoleViewModel (arvm)
// Source: AdminRoleViewModel.swift
//
// filters
// "arvm.filter.all" = "すべて"
// "arvm.filter.codePost" = "コード投稿"
// "arvm.filter.officialEmail" = "公式メール"


// MARK: - AdminStatusDetailViewModel (asdm)
// Source: AdminStatusDetailViewModel.swift
//
// alerts
// "asdm.alert.permissionDenied.title" = "権限がありません"
// "asdm.alert.permissionDenied.msg" = "管理者のみアクセスできます。管理者アカウントでログインして再試行してください。"
// "asdm.alert.warning.title" = "警告"
// "asdm.alert.refreshSummaryFailed.msg" = "ベンダー概要の更新に失敗しました。"
// "asdm.alert.loadDetailFailed.msg" = "ベンダー詳細の読み込みに失敗しました。"
// "asdm.alert.loadImagesFailed.msg" = "ベンダー画像の読み込みに失敗しました。"
//
// rejection
// "asdm.rejection.fallback" = "却下"
//
// rejection categories
// "asdm.rejectCategory.content" = "コンテンツの問題"
// "asdm.rejectCategory.metadata" = "掲載／ラベルの問題"
// "asdm.rejectCategory.policy" = "ポリシー違反"
// "asdm.rejectCategory.manual" = "#手入力#"
//
// rejection templates (display)
// "asdm.rejectTpl.other" = "その他"
// "asdm.rejectTpl.inappropriateContent" = "不適切／誤解を招く内容"
// "asdm.rejectTpl.duplicateListing" = "重複掲載"
// "asdm.rejectTpl.invalidContact" = "無効な連絡先情報"
// "asdm.rejectTpl.rightsUnclear" = "画像／ポートフォリオの権利が不明"
// "asdm.rejectTpl.missingRequiredInfo" = "必須情報の不足"
// "asdm.rejectTpl.policyViolation" = "ポリシー違反"
// "asdm.rejectTpl.outOfScopeService" = "対象外のサービス"
// "asdm.rejectTpl.unsupportedRegion" = "対応外の地域"
// "asdm.rejectTpl.cannotVerifyBusiness" = "事業の正当性を確認できません"
// "asdm.rejectTpl.misleadingInfo" = "誤解を招く／不正確な情報"
// "asdm.rejectTpl.spamOrPromotion" = "スパム／過度な宣伝"
// "asdm.rejectTpl.lowQualityAssets" = "低品質のメディア／内容"
// "asdm.rejectTpl.languageUnsupported" = "非対応言語"
// "asdm.rejectTpl.translationIssue" = "翻訳／ローカライズの問題"
// "asdm.rejectTpl.conflictingOwnershipClaim" = "所有権主張の不一致"
//
// rejection previews
// "asdm.rejectPreview.inappropriateContent" = "提出された内容が不適切、または誤解を招く可能性があります。"
// "asdm.rejectPreview.duplicateListing" = "このベンダーは既存の掲載と重複している可能性があります。"
// "asdm.rejectPreview.invalidContact" = "提供された連絡先情報が無効、または確認できません。"
// "asdm.rejectPreview.rightsUnclear" = "提出された画像／ポートフォリオの権利を確認できません。"
// "asdm.rejectPreview.missingRequiredInfo" = "審査に必要な情報が不足している、または内容が不十分です。"
// "asdm.rejectPreview.policyViolation" = "この申請はプラットフォームポリシーに違反しています。"
// "asdm.rejectPreview.outOfScopeService" = "提供サービスが本プラットフォームの対象範囲外です。"
// "asdm.rejectPreview.unsupportedRegion" = "ベンダー所在地が対応外または制限地域です。"
// "asdm.rejectPreview.cannotVerifyBusiness" = "事業の正当性を確認できませんでした。"
// "asdm.rejectPreview.misleadingInfo" = "提供情報が誤解を招く、誤りがある、または整合しません。"
// "asdm.rejectPreview.spamOrPromotion" = "投稿内容がスパム、または過度な宣伝と判断されました。"
// "asdm.rejectPreview.lowQualityAssets" = "メディアまたは内容の品質が基準を満たしていません。"
// "asdm.rejectPreview.languageUnsupported" = "提出された言語は現在サポートされていません。"
// "asdm.rejectPreview.translationIssue" = "翻訳／ローカライズに問題があります。"
// "asdm.rejectPreview.conflictingOwnershipClaim" = "コンテンツ所有に関して相反する主張があります。"


// MARK: - AdminStatusViewModel (asvm)
// Source: AdminStatusViewModel.swift
//
// alerts
// "asvm.alert.permissionDenied.title" = "権限がありません"
// "asvm.alert.permissionDenied.msg" = "管理者のみアクセスできます。管理者アカウントでログインして再試行してください。"


// MARK: - AdminVendorDetailViewModel (avdvm)
// Source: AdminVendorDetailViewModel.swift
//
// messages
// "avdvm.message.warning.title" = "警告"
// "avdvm.message.refreshSummaryFailed.msg" = "ベンダー概要の更新に失敗しました。"
// "avdvm.message.loadDetailFailed.msg" = "ベンダー詳細の読み込みに失敗しました。"
// "avdvm.message.loadImagesFailed.msg" = "ベンダー画像の読み込みに失敗しました。"
// "avdvm.message.updated.title" = "更新しました"
// "avdvm.message.statusChanged.format" = "ベンダーステータスを%@に変更しました。"
//
// alerts
// "avdvm.alert.error.title" = "エラー"
// "avdvm.alert.sessionExpired.msg" = "セッションの有効期限が切れました。再度ログインしてください。"
// "avdvm.alert.permissionDenied.title" = "権限がありません"
// "avdvm.alert.onlyAdminCanChangeStatus.msg" = "ステータス変更は管理者のみ可能です。"
// "avdvm.alert.failed.title" = "失敗"
// "avdvm.alert.changeStatusFailed.msg" = "ベンダーステータスを変更できませんでした。"


// MARK: - AdminVendorViewModel (avvm)
// Source: AdminVendorViewModel.swift
//
// alerts
// "avvm.alert.error.title" = "エラー"
// "avvm.alert.loadFailed.msg" = "ベンダーの読み込みに失敗しました。もう一度お試しください。"


// MARK: - AdminPortalView (apv)
// Source: AdminPortalView.swift
//
// title
// "apv.title.adminPortal" = "管理者ポータル"
//
// sections
// "apv.section.accountInfo" = "アカウント情報"
//
// user
// "apv.user.format" = "ユーザー：%@"
// "apv.user.roleApplicationCount" = "ロール申請数：??"
// "apv.user.pendingVendorCount" = "審査待ちベンダー数：??"
//
// actions
// "apv.action.manageVendors.title" = "ベンダー管理"
// "apv.action.manageVendors.subtitle" = "ベンダー一覧を確認"
// "apv.action.reviewRoles.title" = "ロール申請を審査"
// "apv.action.reviewRoles.subtitle" = "ロール申請を承認"
// "apv.action.reviewVendors.title" = "審査待ちベンダーを審査"
// "apv.action.reviewVendors.subtitle" = "審査待ちベンダーを承認"
//
// buttons
// "apv.button.ok" = "OK"


// MARK: - AdminRoleDetailView (ardv)
// Source: AdminRoleDetailView.swift
//
// title
// "ardv.title.roleAppDetail" = "ロール申請詳細"
//
// sections
// "ardv.section.status" = "ステータス"
// "ardv.section.applicantDetail" = "申請者情報"
// "ardv.section.businessDetail" = "事業情報"
// "ardv.section.application" = "申請内容"
// "ardv.section.evidence" = "証明"
// "ardv.section.terms" = "規約"
// "ardv.section.decision" = "判定"
// "ardv.section.actions" = "操作"
// "ardv.reject.section.preview" = "プレビュー"
//
// texts
// "ardv.text.appNotFound" = "申請が見つかりません。"
// "ardv.text.noActions" = "この申請に対して可能な操作はありません。"
// "ardv.reject.text.noTemplates" = "テンプレートがありません。"
// "ardv.reject.text.selectTemplateHint" = "テンプレートを選択して却下メッセージをプレビューできます。"
//
// fields
// "ardv.field.name" = "氏名"
// "ardv.field.roleTitle" = "役職"
// "ardv.field.email" = "メールアドレス"
// "ardv.field.phone" = "電話番号"
// "ardv.field.authorityConfirmed" = "権限確認"
// "ardv.field.rightsConfirmed" = "権利確認"
// "ardv.field.brandName" = "ブランド名"
// "ardv.field.category" = "カテゴリ"
// "ardv.field.currentRole" = "現在のロール"
// "ardv.field.requestedRole" = "希望ロール"
// "ardv.field.termsVersion" = "規約バージョン"
// "ardv.field.agreedAt" = "同意日時"
// "ardv.field.result" = "結果"
// "ardv.field.reviewer" = "レビュアー"
// "ardv.field.decidedAt" = "判定日時"
// "ardv.field.rejectionCategory" = "カテゴリ"
//
// common buttons
// "ardv.button.cancel" = "キャンセル"
// "ardv.button.confirm" = "確認"
// "ardv.button.reject" = "却下"
// "ardv.button.approve" = "承認"
//
// toasts
// "ardv.toast.needLogin" = "ログインが必要です"
// "ardv.toast.copied" = "コピーしました。"
//
// approve/reject sheet
// "ardv.reject.title" = "ロール申請を却下"
// "ardv.reject.field.category" = "カテゴリ"
// "ardv.reject.field.template" = "テンプレート"
// "ardv.reject.placeholder.detailOptional" = "詳細を追加（任意）"
// "ardv.approve.title" = "申請を承認"
//
// evidence
// "ardv.evidence.method.officialEmail" = "公式メール"
// "ardv.evidence.method.codePost" = "コード投稿"
// "ardv.evidence.submittedAt.format" = "提出：%@"
// "ardv.evidence.field.email" = "メールアドレス"
// "ardv.evidence.field.url" = "URL"
// "ardv.evidence.field.code" = "コード"
// "ardv.evidence.button.verified" = "証明確認済み"
// "ardv.evidence.alert.verify.title" = "証明を確認しますか？"
// "ardv.evidence.alert.verify.msg" = "証明を「確認済み」にします。"


// MARK: - AdminRoleView (arv)
// Source: AdminRoleView.swift
//
// navigation
// "arv.nav.title" = "ロール申請"
//
// tabs
// "arv.tab.pending" = "審査中"
// "arv.tab.history" = "履歴"
//
// header
// "arv.header.subtitle" = "ベンダーロール申請を審査します"
//
// buttons
// "arv.button.ok" = "OK"
//
// empty
// "arv.empty.pending" = "審査中の申請はありません。"
// "arv.empty.history" = "履歴はありません。"
// "arv.empty.hint" = "ユーザーが申請を送信すると、ここに表示されます。"
//
// row
// "arv.row.noBrand" = "（ブランド名なし）"
// "arv.row.applicant.format" = "申請者：%@"
// "arv.row.method.format" = "方法：%@"
// "arv.row.method.unknown" = "不明"


// MARK: - AdminStatusDetailView (asdv)
// Source: AdminStatusDetailView.swift
//
// navigation
// "asdv.nav.title" = "審査"
//
// titles
// "asdv.title.applicationDetail" = "申請詳細"
//
// sections
// "asdv.section.commentFromVendor" = "ベンダーからのコメント"
// "asdv.section.actions" = "操作"
//
// fields
// "asdv.field.request" = "申請内容"
// "asdv.field.decision" = "判定"
// "asdv.field.vendorId" = "ベンダーID"
// "asdv.field.applicantUserId" = "申請者ユーザーID"
// "asdv.field.termsVersion" = "規約バージョン"
// "asdv.field.agreedAt" = "同意日時"
// "asdv.field.created" = "作成"
// "asdv.field.updated" = "更新"
//
// buttons
// "asdv.button.ok" = "OK"
// "asdv.button.cancel" = "キャンセル"
// "asdv.button.reject" = "却下"
// "asdv.button.approve" = "承認"
// "asdv.button.showReviewScreen" = "審査画面を表示"
//
// texts
// "asdv.text.alreadyDecided.format" = "この申請は既に%@です。"
//
// toasts
// "asdv.toast.copiedVendorId" = "VendorIDをコピーしました。"
// "asdv.toast.copiedUserId" = "UserIDをコピーしました。"
//
// alerts
// "asdv.alert.invalidPath.title" = "この画面を開けません"
// "asdv.alert.invalidPath.msg" = "アクセス経路が無効、または必要なデータが不足しています。"
// "asdv.alert.error.title" = "エラー"
// "asdv.alert.approveFailed.msg" = "申請の承認に失敗しました。"
// "asdv.alert.rejectFailed.msg" = "申請の却下に失敗しました。"
//
// approve/reject sheet
// "asdv.reject.title.format" = "%@申請を却下"
// "asdv.reject.field.category" = "カテゴリ"
// "asdv.reject.field.template" = "テンプレート"
// "asdv.reject.section.preview" = "プレビュー"
// "asdv.reject.placeholder.detailOptional" = "詳細を追加（任意）"
// "asdv.reject.hint.appended" = "このメモは却下理由に追記されます。"
// "asdv.approve.title.format" = "%@申請を承認"


// MARK: - AdminStatusView (asv)
// Source: AdminStatusView.swift
//
// navigation
// "asv.nav.title" = "ステータス審査"
//
// tabs
// "asv.tab.pending" = "審査中"
// "asv.tab.history" = "履歴"
//
// header
// "asv.header.title" = "ステータス申請"
// "asv.header.countPending.format" = "審査中：%d件"
// "asv.header.countHistory.format" = "履歴：%d件"
//
// menu
// "asv.menu.requestType" = "申請種別"
// "asv.menu.decision" = "判定"
// "asv.menu.all" = "すべて"
//
// buttons
// "asv.button.ok" = "OK"
//
// empty
// "asv.empty.pending.title" = "審査中の申請はありません"
// "asv.empty.pending.subtitle" = "一時的なネットワークエラーの可能性があります。後でもう一度お試しください。"
// "asv.empty.history.title" = "履歴はありません"
// "asv.empty.history.subtitle" = "承認／却下／キャンセルの結果がここに表示されます。"
//
// sections
// "asv.section.actionRequired" = "要対応"
// "asv.section.history" = "履歴"
//
// filters
// "asv.filter.all" = "すべて"
//
// row
// "asv.row.vendorId.format" = "ベンダーID：%@"
// "asv.row.applicantId.format" = "申請者ID：%@"
// "asv.row.terms.format" = "規約：%@"


// MARK: - AdminVendorDetailView (avdv)
// Source: AdminVendorDetailView.swift
//
// menu
// "avdv.menu.copyVendorId" = "ベンダーIDをコピー"
// "avdv.menu.changeStatus" = "ステータス変更"
//
// sections
// "avdv.section.status" = "ステータス"
//
// buttons
// "avdv.button.cancel" = "キャンセル"
// "avdv.button.apply" = "適用"
// "avdv.button.confirm" = "確認"
// "avdv.button.open" = "開く"
// "avdv.button.ok" = "OK"
//
// alerts
// "avdv.alert.confirmChange.title" = "変更確認"
// "avdv.alert.confirmChange.format" = "『%@』を『%@』に変更しますか？"
// "avdv.alert.openExternal.title" = "外部リンクを開きますか？"
//
// toasts
// "avdv.toast.copied" = "コピーしました。"


// MARK: - AdminVendorView (avv)
// Source: AdminVendorView.swift
//
// filters
// "avv.filter.status.all" = "すべて"
//
// search
// "avv.search.prompt" = "検索"
//
// buttons
// "avv.button.ok" = "OK"


// MARK: - HomeView (hv)
// Source: HomeView.swift
//
// titles
// "hv.title.main" = "Pumpkin Carriage"
// "hv.title.marks" = "マーク"
// "hv.title.my" = "マイ"
// "hv.title.profile" = "プロフィール"
//
// tabs
// "hv.tab.main" = "メイン"
// "hv.tab.marks" = "マーク"
// "hv.tab.my" = "マイ"
// "hv.tab.profile" = "プロフィール"
//
// alerts
// "hv.alert.signInRequired.title" = "ログインが必要です"
// "hv.alert.signInRequired.msg" = "マークを表示するにはログインしてください。"
//
// buttons
// "hv.button.ok" = "OK"


// MARK: - RoleApplicationForm (raf)
// Source: RoleApplicationForm.swift
//
// evidence helper
// "raf.evidenceHelper.officialEmail" = "公式メールのヒントと、そのメールが掲載／使用されている公開URLを入力し、下記アドレスへメールを送信してください。"
// "raf.evidenceHelper.codePost" = "公式チャンネル（Webサイト、Instagram、YouTube、X 等）に認証コードを掲載し、URLと掲載場所の詳細を入力して送信してください。"

// MARK: - SettingView (setv)
// Source: SettingView.swift
//
// titles
// "setv.title.settings" = "設定"
//
// rows & navigation
// "setv.row.appVersion" = "アプリバージョン"
// "setv.nav.terms" = "利用規約"
// "setv.nav.privacy" = "プライバシーポリシー"
// "setv.nav.language" = "言語"
//
// language options
// "setv.lang.systemDefault" = "システム設定"
// "setv.lang.ko" = "한국어"
// "setv.lang.en" = "English"
// "setv.lang.ja" = "日本語"




// MARK: - Validation (vld)
// Source: Validation.swift
//
// titles
// "vld.title.invalidEmail" = "無効なメールアドレス"
// "vld.title.invalidPassword" = "無効なパスワード"
// "vld.title.invalidUsername" = "無効なユーザー名"
// "vld.title.invalid" = "無効です"
// "vld.title.invalidInput" = "無効な入力"
// "vld.title.invalidPhone" = "無効な電話番号"
// "vld.title.invalidExternalLink" = "無効な外部リンク"
//
// messages
// "vld.msg.requiredFields" = "必須項目をすべて入力してください。"
// "vld.msg.emailMin.format" = "メールアドレスは%d文字以上で入力してください。"
// "vld.msg.emailFormat" = "正しいメールアドレス形式で入力してください。"
// "vld.msg.passwordMin.format" = "パスワードは%d文字以上で入力してください。"
// "vld.msg.usernameRange.format" = "ユーザー名は%d〜%d文字で入力してください。"
// "vld.msg.usernameChars" = "ユーザー名には英数字、ドット（.）、アンダースコア（_）、ハイフン（-）のみ使用できます。"
// "vld.msg.loginEmpty" = "ユーザー名とパスワードを入力してください。"
// "vld.msg.phoneCountryCodeRequired" = "電話番号の国コードを選択してください。"
// "vld.msg.phoneDigitsOnly" = "数字のみを入力してください（空白や記号は使用できません）。"
// "vld.msg.phoneMinDigits.format" = "電話番号は%d桁以上で入力してください。"
// "vld.msg.externalLinkFields" = "外部リンクの項目をすべて入力するか、不要な行を削除してください。"
// "vld.msg.phoneNumberRequired" = "電話番号を入力するか、国コードの選択を解除してください。"
//
// english-only helper
// "vld.englishOnly.title.format" = "無効な%@"
// "vld.englishOnly.msg.format" = "%@は英語（ローマ字）で入力してください。"



// MARK: - VendorWriteService (vws)
// Source: VendorWriteService.swift
//
// alerts
// "vws.alert.permissionDenied.title" = "権限がありません"
// "vws.alert.error.title" = "エラー"
// "vws.alert.imageUploadFailed.title" = "画像のアップロードに失敗しました"
// "vws.alert.saveFailed.title" = "保存に失敗しました"
// "vws.alert.updateNotAllowed.title" = "更新できません"
//
// messages
// "vws.alert.tryAgain.msg" = "もう一度お試しください。"
// "vws.alert.registerOnlyVendorOrAdmin.msg" = "ベンダーまたは管理者のみがベンダーを登録できます。"
// "vws.alert.registerSaveFailed.msg" = "ベンダーの登録に失敗しました。もう一度お試しください。"
// "vws.alert.sessionInvalid.msg" = "セッションが無効です。再度ログインしてください。"
// "vws.alert.vendorNotFoundForUpdate.msg" = "更新対象のベンダーが見つかりません。"
// "vws.alert.updateNotAllowed.msg" = "このベンダーは審査中またはアーカイブ済みのため更新できません。"
// "vws.alert.noPermissionToEdit.msg" = "このベンダーを編集する権限がありません。"
// "vws.alert.updateSaveFailed.msg" = "ベンダーの更新に失敗しました。もう一度お試しください。"
// "vws.alert.updateStatusOnlyVendorOrAdmin.msg" = "ベンダーまたは管理者のみがステータスを更新できます。"
// "vws.alert.vendorNotFound.msg" = "ベンダーが見つかりません。"
// "vws.alert.noPermissionToUpdate.msg" = "このベンダーを更新する権限がありません。"



// MARK: - ImageResourceView (irv)
// Source: ImageResourceView.swift
//
// placeholder
// "irv.placeholder.imageNotFound" = "画像が見つかりません"
// "irv.placeholder.failedToLoad" = "読み込みに失敗しました"



// MARK: - PasswordComponentView (pcv)
// Source: PasswordComponentView.swift
//
// placeholders
// "pcv.placeholder.password" = "パスワード"



// MARK: - VendorDetailComponentView (vdcv)
// Source: VendorDetailComponentView.swift
//
// toasts
// "vdcv.toast.waitMoment" = "しばらくお待ちください。"
// "vdcv.toast.copied" = "コピーしました。"
// "vdcv.toast.signInToCopy" = "コピーするにはログインしてください。"
// "vdcv.toast.signInToShare" = "共有するにはログインしてください。"
// "vdcv.toast.signInToUseBookmarks" = "ブックマークを利用するにはログインしてください。"
// "vdcv.toast.signInToOpenLinks" = "外部リンクを開くにはログインしてください。"
//
// sheet
// "vdcv.sheet.introTitle.format" = "%@の紹介"
//
// alert
// "vdcv.alert.copy.title" = "クリップボードにコピーしますか？"
//
// buttons
// "vdcv.button.copy" = "コピー"
// "vdcv.button.cancel" = "キャンセル"
// "vdcv.button.seeMore" = "もっと見る"
// "vdcv.button.hide" = "非表示"
// "vdcv.button.reveal" = "表示"
//
// labels
// "vdcv.label.category" = "カテゴリ："
// "vdcv.label.languages" = "対応言語："
//
// map
// "vdcv.text.signInToViewMap" = "地図を表示するにはログインしてください。"
//
// sections
// "vdcv.section.contact" = "連絡先・外部リンク"
//
// contact
// "vdcv.contact.email" = "メール"
// "vdcv.contact.phone" = "電話番号"
// "vdcv.contact.phoneWithCountry.format" = "電話番号（%@）"
//
// accessibility
// "vdcv.a11y.signInRequired" = "ログインが必要です"
//
// description view defaults
// "vdcv.desc.defaultTitle" = "説明タイトル"
// "vdcv.desc.defaultBody" = "説明文がここに表示されます"



// MARK: - VendorFilterSheetView (vfs)
// Source: VendorFilterSheetView.swift
//
// buttons
// "vfs.button.cancel" = "キャンセル"
// "vfs.button.reset" = "リセット"
// "vfs.button.apply" = "適用"
//
// sections
// "vfs.section.location" = "場所"
// "vfs.section.language" = "言語"
//
// fields
// "vfs.field.country" = "国"
// "vfs.field.city" = "市区町村"
// "vfs.field.district" = "地区"
//
// preview
// "vfs.preview.tapToShow" = "タップしてフィルターを表示"
