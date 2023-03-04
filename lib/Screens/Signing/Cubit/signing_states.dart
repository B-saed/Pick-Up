abstract class SigningStates {}

class SigningInitialState extends SigningStates {}

class ChangePasswordVisibilityState extends SigningStates {}

class CheckingInternetConnectivityState extends SigningStates {}
class InternetConnectedState extends SigningStates {}
class InternetDisconnectedState extends SigningStates {}

/// Login States
class LoginLoadingState extends SigningStates {}

class LoginSuccessState extends SigningStates {}

class LoginErrorState extends SigningStates {}

/// Register States
class RegisterLoadingState extends SigningStates {}

class RegisterSuccessState extends SigningStates {}

class RegisterErrorState extends SigningStates {}

/// User Creating States
class UserCreateSuccessState extends SigningStates {}

class UserCreateErrorState extends SigningStates {}

/// Purging States
class UserDeleteFromAuthSuccessState extends SigningStates {}

class UserDeleteFromAuthErrorState extends SigningStates {}

class UserDeleteFromDBSuccessState extends SigningStates {}

class UserDeleteFromDBErrorState extends SigningStates {}


/// Email Verification States
class EmailVerificationSentSuccessState extends SigningStates {}

class WaitingForVerificationState extends SigningStates {}

class EmailVerificationCompleteState extends SigningStates {}

class EmailVerificationErrorState extends SigningStates {}

