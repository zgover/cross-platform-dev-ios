/** @file FIRAuth.h
    @brief Firebase Auth SDK
    @copyright Copyright 2015 Google Inc.
    @remarks Use of this SDK is subject to the Google APIs Terms of Service:
        https://developers.google.com/terms/
 */

#import <Foundation/Foundation.h>

#import <FirebaseAuth/FIRAuthErrors.h>

@class FIRApp;
@class FIRAuth;
@class FIRAuthCredential;
@class FIRUser;
@protocol FIRAuthStateListener;

NS_ASSUME_NONNULL_BEGIN

/** @typedef FIRAuthStateDidChangeListenerHandle
    @brief The type of handle returned by @c FIRAuth.addAuthStateDidChangeListener:.
 */
typedef id<NSObject> FIRAuthStateDidChangeListenerHandle;

/** @typedef FIRAuthStateDidChangeListenerBlock
    @brief The type of block which can be registered as a listener for auth state did change events.

    @param auth The FIRAuth object on which state changes occurred.
    @param user Optionally; the current signed in user, if any.
 */
typedef void(^FIRAuthStateDidChangeListenerBlock)(FIRAuth *auth, FIRUser *_Nullable user);

/** @var FIRAuthStateDidChangeNotification
    @brief The name of the @c NSNotificationCenter notification which is posted when the auth state
        changes (for example, a new token has been produced, a user signs in or signs out). The
        object parameter of the notification is the sender @c FIRAuth instance.
 */
extern NSString *const FIRAuthStateDidChangeNotification;

/** @typedef FIRAuthResultCallback
    @brief The type of block invoked when sign-in related events complete.

    @param user Optionally; the signed in user, if any.
    @param error Optionally; if an error occurs, this is the NSError object that describes the
        problem. Set to nil otherwise.
 */
typedef void (^FIRAuthResultCallback)(FIRUser *_Nullable user, NSError *_Nullable error);

/** @typedef FIRProviderQueryCallback
    @brief The type of block invoked when a list of identity providers for a given email address is
        requested.

    @param providers Optionally; a list of provider identifiers, if any.
        @see FIRGoogleAuthProviderID etc.
    @param error Optionally; if an error occurs, this is the NSError object that describes the
        problem. Set to nil otherwise.
 */
typedef void (^FIRProviderQueryCallback)(NSArray<NSString *> *_Nullable providers,
                                         NSError *_Nullable error);

/** @typedef FIRSendPasswordResetCallback
    @brief The type of block invoked when sending a password reset email.

    @param error Optionally; if an error occurs, this is the NSError object that describes the
        problem. Set to nil otherwise.
 */
typedef void (^FIRSendPasswordResetCallback)(NSError *_Nullable error);

/** @typedef FIRConfirmPasswordResetCallback
    @brief The type of block invoked when performing a password reset.

    @param error Optionally; if an error occurs, this is the NSError object that describes the
        problem. Set to nil otherwise.
 */
typedef void (^FIRConfirmPasswordResetCallback)(NSError *_Nullable error);

/** @typedef FIRVerifyPasswordResetCodeCallback
    @brief The type of block invoked when verifying that an out of band code should be used to
        perform password reset.

    @param email Optionally; the email address of the user for which the out of band code applies.
    @param error Optionally; if an error occurs, this is the NSError object that describes the
        problem. Set to nil otherwise.
 */
typedef void (^FIRVerifyPasswordResetCodeCallback)(NSString *_Nullable email,
                                                   NSError *_Nullable error);

/** @typedef FIRApplyActionCodeCallback
    @brief The type of block invoked when applying an action code.

    @param error Optionally; if an error occurs, this is the NSError object that describes the
        problem. Set to nil otherwise.
 */
typedef void (^FIRApplyActionCodeCallback)(NSError *_Nullable error);

/** @enum FIRActionDataKey
    @brief Keys used to retrieve operation data from a @c FIRActionCodeInfo object by the @c
        dataForKey method.
  */
typedef NS_ENUM(NSInteger, FIRActionDataKey) {
  /**
   * The email address to which the code was sent.
   * For FIRActionCodeOperationRecoverEmail, the new email address for the account.
   */
  FIRActionCodeEmailKey = 0,

  /** For FIRActionCodeOperationRecoverEmail, the current email address for the account. */
  FIRActionCodeFromEmailKey = 1
};

/** @class FIRActionCodeInfo
    @brief Manages information regarding action codes.
 */
@interface FIRActionCodeInfo : NSObject

/** @enum FIRActionCodeOperation
    @brief Operations which can be performed with action codes.
  */
typedef NS_ENUM(NSInteger, FIRActionCodeOperation) {
    /** Action code for unknown operation. */
    FIRActionCodeOperationUnknown = 0,

    /** Action code for password reset operation. */
    FIRActionCodeOperationPasswordReset = 1,

    /** Action code for verify email operation. */
    FIRActionCodeOperationVerifyEmail = 2
};

/** @var operation.
    @brief The operation being performed.
 */
@property(nonatomic, readonly) FIRActionCodeOperation operation;

/** @fn dataForKey:
    @brief The operation being performed.

    @param key The FIRActionDataKey value used to retrieve the operation data.

    @return The operation data pertaining to the provided action code key.
 */
- (NSString *)dataForKey:(FIRActionDataKey)key;

/** @fn init
    @brief please use initWithOperation: instead.
 */
- (instancetype)init NS_UNAVAILABLE;

@end

/** @typedef FIRCheckActionCodeCallBack
    @brief The type of block invoked when performing a check action code operation.

    @param info Metadata corresponding to the action code.
    @param error Optionally; if an error occurs, this is the NSError object that describes the
        problem. Set to nil otherwise.
 */
typedef void (^FIRCheckActionCodeCallBack)(FIRActionCodeInfo *_Nullable info,
                                           NSError *_Nullable error);

/** @class FIRAuth
    @brief Manages authentication for Firebase apps.
    @remarks This class is thread-safe.
 */
@interface FIRAuth : NSObject

/** @fn auth
    @brief Gets the auth object for the default Firebase app.
    @remarks Thread safe.
 */
+ (nullable FIRAuth *)auth NS_SWIFT_NAME(auth());

/** @fn authWithApp:
    @brief Gets the auth object for a @c FIRApp.

    @param app The FIRApp for which to retrieve the associated FIRAuth instance.
    @return The FIRAuth instance associated with the given FIRApp.
 */
+ (nullable FIRAuth *)authWithApp:(FIRApp *)app;

/** @property app
    @brief Gets the @c FIRApp object that this auth object is connected to.
 */
@property(nonatomic, weak, readonly, nullable) FIRApp *app;

/** @property currentUser
    @brief Synchronously gets the cached current user, or null if there is none.
 */
@property(nonatomic, strong, readonly, nullable) FIRUser *currentUser;

/** @fn init
    @brief Please access auth instances using @c FIRAuth.auth and @c FIRAuth.authForApp:.
 */
- (instancetype)init NS_UNAVAILABLE;

/** @fn fetchProvidersForEmail:completion:
    @brief Fetches the list of IdPs that can be used for signing in with the provided email address.
        Useful for an "identifier-first" sign-in flow.

    @param email The email address for which to obtain a list of identity providers.
    @param completion Optionally; a block which is invoked when the list of providers for the
        specified email address is ready or an error was encountered. Invoked asynchronously on the
        main thread in the future.

    @remarks Possible error codes:
    <ul>
        <li>@c FIRAuthErrorCodeInvalidEmail - Indicates the email address is malformed.</li>
    </ul>

    @remarks See @c FIRAuthErrors for a list of error codes that are common to all API methods.
 */
- (void)fetchProvidersForEmail:(NSString *)email
                    completion:(nullable FIRProviderQueryCallback)completion;

/** @fn signInWithEmail:password:completion:
    @brief Signs in using an email address and password.

    @param email The user's email address.
    @param password The user's password.
    @param completion Optionally; a block which is invoked when the sign in flow finishes, or is
        canceled. Invoked asynchronously on the main thread in the future.

    @remarks Possible error codes:

    <ul>
        <li>@c FIRAuthErrorCodeOperationNotAllowed - Indicates that email and password
            accounts are not enabled. Enable them in the Auth section of the
            Firebase console.
        </li>
        <li>@c FIRAuthErrorCodeUserDisabled - Indicates the user's account is disabled.
        </li>
        <li>@c FIRAuthErrorCodeWrongPassword - Indicates the user attempted
            sign in with an incorrect password.
        </li>
        <li>@c FIRAuthErrorCodeInvalidEmail - Indicates the email address is malformed.
        </li>
    </ul>

    @remarks See @c FIRAuthErrors for a list of error codes that are common to all API methods.
 */
- (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(nullable FIRAuthResultCallback)completion;

/** @fn signInWithCredential:completion:
    @brief Asynchronously signs in to Firebase with the given 3rd-party credentials (e.g. a Facebook
        login Access Token, a Google ID Token/Access Token pair, etc.)

    @param credential The credential supplied by the IdP.
    @param completion Optionally; a block which is invoked when the sign in flow finishes, or is
        canceled. Invoked asynchronously on the main thread in the future.

    @remarks Possible error codes:
    <ul>
        <li>@c FIRAuthErrorCodeInvalidCredential - Indicates the supplied credential is invalid.
            This could happen if it has expired or it is malformed.
        </li>
        <li>@c FIRAuthErrorCodeOperationNotAllowed - Indicates that accounts
            with the identity provider represented by the credential are not enabled.
            Enable them in the Auth section of the Firebase console.
        </li>
        <li>@c FIRAuthErrorCodeEmailAlreadyInUse - Indicates the email asserted by the credential
            (e.g. the email in a Facebook access token) is already in use by an existing account,
            that cannot be authenticated with this sign-in method. Call fetchProvidersForEmail for
            this user???s email and then prompt them to sign in with any of the sign-in providers
            returned. This error will only be thrown if the "One account per email address"
            setting is enabled in the Firebase console, under Auth settings. Please note that the
            error code raised in this specific situation may not be the same on
            Web and Android.
        </li>
        <li>@c FIRAuthErrorCodeUserDisabled - Indicates the user's account is disabled.
        </li>
        <li>@c FIRAuthErrorCodeWrongPassword - Indicates the user attempted sign in with an
            incorrect password, if credential is of the type EmailPasswordAuthCredential.
        </li>
        <li>@c FIRAuthErrorCodeInvalidEmail - Indicates the email address is malformed.
        </li>
    </ul>

    @remarks See @c FIRAuthErrors for a list of error codes that are common to all API methods.
 */
- (void)signInWithCredential:(FIRAuthCredential *)credential
                  completion:(nullable FIRAuthResultCallback)completion;

/** @fn signInAnonymouslyWithCompletion:
    @brief Asynchronously creates and becomes an anonymous user.
    @param completion Optionally; a block which is invoked when the sign in finishes, or is
        canceled. Invoked asynchronously on the main thread in the future.

    @remarks If there is already an anonymous user signed in, that user will be returned instead.
        If there is any other existing user signed in, that user will be signed out.

    @remarks Possible error codes:
    <ul>
        <li>@c FIRAuthErrorCodeOperationNotAllowed - Indicates that anonymous accounts are
            not enabled. Enable them in the Auth section of the Firebase console.
        </li>
    </ul>

    @remarks See @c FIRAuthErrors for a list of error codes that are common to all API methods.
 */
- (void)signInAnonymouslyWithCompletion:(nullable FIRAuthResultCallback)completion;

/** @fn signInWithCustomToken:completion:
    @brief Asynchronously signs in to Firebase with the given Auth token.

    @param token A self-signed custom auth token.
    @param completion Optionally; a block which is invoked when the sign in finishes, or is
        canceled. Invoked asynchronously on the main thread in the future.

    @remarks Possible error codes:
    <ul>
        <li>@c FIRAuthErrorCodeInvalidCustomToken - Indicates a validation error with
            the custom token.
        </li>
        <li>@c FIRAuthErrorCodeCustomTokenMismatch - Indicates the service account and the API key
            belong to different projects.
        </li>
    </ul>

    @remarks See @c FIRAuthErrors for a list of error codes that are common to all API methods.
 */
- (void)signInWithCustomToken:(NSString *)token
                   completion:(nullable FIRAuthResultCallback)completion;

/** @fn createUserWithEmail:password:completion:
    @brief Creates and, on success, signs in a user with the given email address and password.

    @param email The user's email address.
    @param password The user's desired password.
    @param completion Optionally; a block which is invoked when the sign up flow finishes, or is
        canceled. Invoked asynchronously on the main thread in the future.

    @remarks Possible error codes:
    <ul>
        <li>@c FIRAuthErrorCodeInvalidEmail - Indicates the email address is malformed.
        </li>
        <li>@c FIRAuthErrorCodeEmailAlreadyInUse - Indicates the email used to attempt sign up
            already exists. Call fetchProvidersForEmail to check which sign-in mechanisms the user
            used, and prompt the user to sign in with one of those.
        </li>
        <li>@c FIRAuthErrorCodeOperationNotAllowed - Indicates that email and password accounts
            are not enabled. Enable them in the Auth section of the Firebase console.
        </li>
        <li>@c FIRAuthErrorCodeWeakPassword - Indicates an attempt to set a password that is
            considered too weak. The NSLocalizedFailureReasonErrorKey field in the NSError.userInfo
            dictionary object will contain more detailed explanation that can be shown to the user.
        </li>
    </ul>

    @remarks See @c FIRAuthErrors for a list of error codes that are common to all API methods.
 */
- (void)createUserWithEmail:(NSString *)email
                   password:(NSString *)password
                 completion:(nullable FIRAuthResultCallback)completion;

/** @fn confirmPasswordResetWithCode:newPassword:completion:
    @brief Resets the password given a code sent to the user outside of the app and a new password
      for the user.

    @param newPassword The new password.
    @param completion Optionally; a block which is invoked when the request finishes. Invoked
        asynchronously on the main thread in the future.

    @remarks Possible error codes:
    <ul>
        <li>@c FIRAuthErrorCodeWeakPassword - Indicates an attempt to set a password that is
            considered too weak.
        </li>
        <li>@c FIRAuthErrorCodeOperationNotAllowed - Indicates the administrator disabled sign
            in with the specified identity provider.
        </li>
        <li>@c FIRAuthErrorCodeExpiredActionCode - Indicates the OOB code is expired.
        </li>
        <li>@c FIRAuthErrorCodeInvalidActionCode - Indicates the OOB code is invalid.
        </li>
   </ul>

    @remarks See @c FIRAuthErrors for a list of error codes that are common to all API methods.
 */
- (void)confirmPasswordResetWithCode:(NSString *)code
                         newPassword:(NSString *)newPassword
                          completion:(FIRConfirmPasswordResetCallback)completion;

/** @fn checkActionCode:completion:
    @brief Checks the validity of an out of band code.

    @param code The out of band code to check validity.
    @param completion Optionally; a block which is invoked when the request finishes. Invoked
        asynchronously on the main thread in the future.
 */
- (void)checkActionCode:(NSString *)code completion:(FIRCheckActionCodeCallBack)completion;

/** @fn verifyPasswordResetCode:completion:
    @brief Checks the validity of a verify password reset code.

    @param code The password reset code to be verified.
    @param completion Optionally; a block which is invoked when the request finishes. Invoked
        asynchronously on the main thread in the future.
 */
- (void)verifyPasswordResetCode:(NSString *)code
                     completion:(FIRVerifyPasswordResetCodeCallback)completion;

/** @fn applyActionCode:completion:
    @brief Applies out of band code.

    @param code The out of band code to be applied.
    @param completion Optionally; a block which is invoked when the request finishes. Invoked
        asynchronously on the main thread in the future.

    @remarks This method will not work for out of band codes which require an additional parameter,
        such as password reset code.
 */
- (void)applyActionCode:(NSString *)code
             completion:(FIRApplyActionCodeCallback)completion;

/** @fn sendPasswordResetWithEmail:completion:
    @brief Initiates a password reset for the given email address.

    @param email The email address of the user.
    @param completion Optionally; a block which is invoked when the request finishes. Invoked
        asynchronously on the main thread in the future.

    @remarks See @c FIRAuthErrors for a list of error codes that are common to all API methods.
 */
- (void)sendPasswordResetWithEmail:(NSString *)email
                        completion:(nullable FIRSendPasswordResetCallback)completion;

/** @fn signOut:
    @brief Signs out the current user.

    @param error Optionally; if an error occurs, upon return contains an NSError object that
        describes the problem; is nil otherwise.
    @return @YES when the sign out request was successful. @NO otherwise.

    @remarks Possible error codes:
    <ul>
        <li>@c FIRAuthErrorCodeKeychainError - Indicates an error occurred when accessing the
            keychain. The @c NSLocalizedFailureReasonErrorKey field in the @c NSError.userInfo
            dictionary will contain more information about the error encountered.
        </li>
    </ul>

 */
- (BOOL)signOut:(NSError *_Nullable *_Nullable)error;

/** @fn addAuthStateDidChangeListener:
    @brief Registers a block as an "auth state did change" listener. To be invoked when:

      + The block is registered as a listener,
      + The current user changes, or,
      + The current user's access token changes.

    @param listener The block to be invoked. The block is always invoked asynchronously on the main
        thread, even for it's initial invocation after having been added as a listener.

    @remarks The block is invoked immediately after adding it according to it's standard invocation
        semantics, asynchronously on the main thread. Users should pay special attention to
        making sure the block does not inadvertently retain objects which should not be retained by
        the long-lived block. The block itself will be retained by @c FIRAuth until it is
        unregistered or until the @c FIRAuth instance is otherwise deallocated.

    @return A handle useful for manually unregistering the block as a listener.
 */
- (FIRAuthStateDidChangeListenerHandle)addAuthStateDidChangeListener:
    (FIRAuthStateDidChangeListenerBlock)listener;

/** @fn removeAuthStateDidChangeListener:
    @brief Unregisters a block as an "auth state did change" listener.

    @param listenerHandle The handle for the listener.
 */
- (void)removeAuthStateDidChangeListener:(FIRAuthStateDidChangeListenerHandle)listenerHandle;

@end

NS_ASSUME_NONNULL_END
