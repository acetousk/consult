<style>
.Login .form-signin { width: 430px !important; }
</style>
<div id="browser-warning" class="hidden text-center" style="margin-bottom: 80px;">
    <h4 class="text-danger">Your browser is not supported, please use a recent version of one of the following:</h4>
    <div class="row" style="font-size: 4em;">
        <div class="col-sm-2"></div>
        <div class="col-sm-2"><a href="https://www.google.com/chrome/"><i class="fa fa-chrome"></i></a></div>
        <div class="col-sm-2"><a href="https://www.mozilla.org/firefox/"><i class="fa fa-firefox"></i></a></div>
        <div class="col-sm-2"><a href="https://www.apple.com/safari/"><i class="fa fa-safari"></i></a></div>
        <div class="col-sm-2"><a href="https://www.microsoft.com/windows/microsoft-edge"><i class="fa fa-edge"></i></a></div>
        <div class="col-sm-2"></div>
    </div>
</div>
<!-- currently general/common HTML5 and ES5 support is currently required, so check for IE and older browsers -->
<!-- TODO: check for older versions of various browsers, or for HTML5 features like input/etc.@form attribute, ES5 stuff -->
<script>
    var UA = window.navigator.userAgent.toLowerCase();
    var isIE = UA && /msie|trident/.test(UA);
    if (isIE) $("#browser-warning").removeClass("hidden");
</script>

<div class="text-center form-signin">
    <ul class="nav nav-tabs" role="tablist">
        <li role="presentation"><a href="#login" aria-controls="login" role="tab" data-toggle="tab">${ec.l10n.localize("Login")}</a></li>
        <#if authFlowList?has_content && !authFlowList.isEmpty()><li role="presentation"><a href="#sso" aria-controls="sso" role="tab" data-toggle="tab">${ec.l10n.localize("SSO")}</a></li></#if>
        <li role="presentation"><a href="#signup" aria-controls="signup" role="tab" data-toggle="tab">${ec.l10n.localize("Sign Up")}</a></li>
        <li role="presentation"><a href="#reset" aria-controls="reset" role="tab" data-toggle="tab">${ec.l10n.localize("Reset Password")}</a></li>
        <li role="presentation"><a href="#change" aria-controls="change" role="tab" data-toggle="tab">${ec.l10n.localize("Change Password")}</a></li>
    </ul>
</div>
<#-- old 'tabs' more like links:
<div class="text-center">
    <ul class="list-inline">
        <li><a class="text-primary" href="#login" data-toggle="tab">${ec.l10n.localize("Login")}</a></li>
        <li><a class="text-primary" href="#reset" data-toggle="tab">${ec.l10n.localize("Reset Password")}</a></li>
        <li><a class="text-primary" href="#change" data-toggle="tab">${ec.l10n.localize("Change Password")}</a></li>
    </ul>
</div>
-->
<div class="tab-content">
    <div id="login" class="tab-pane active">
        <form method="post" action="${sri.buildUrl("login").url}" class="form-signin" id="login_form">
            <input type="hidden" name="initialTab" value="login">
            <#-- people know what to do <p class="text-muted text-center">${ec.l10n.localize("Enter your username and password to sign in")}</p> -->
            <#-- not needed for this request: <input type="hidden" name="moquiSessionToken" value="${ec.web.sessionToken}"> -->
            <input id="login_form_username" name="username" type="text" value="${(username!"")?html}"
                    <#if username?has_content && secondFactorRequired>disabled="disabled"</#if>
                    required="required" class="form-control top"
                    placeholder="${ec.l10n.localize("Username")}" aria-label="${ec.l10n.localize("Username")}">
            <script>
                // Default to username parameter from URL
                const urlParams = new URLSearchParams(window.location.search);
                const usernameParam = urlParams.get('username');
                if (usernameParam && !document.getElementById('login_form_username').value) {
                    document.getElementById('login_form_username').value = usernameParam;
                }
            </script>
            <#-- secondFactorRequired will only be set if a user is pre-authenticated, and in that case password not required again -->
            <#if secondFactorRequired>
                <input id="login_form_code" name="code" type="text" inputmode="numeric" autocomplete="one-time-code"
                       required="required" class="form-control bottom"
                       placeholder="${ec.l10n.localize("Authentication Code")}" aria-label="${ec.l10n.localize("Authentication Code")}">
            <#else>
                <input type="password" name="password" required="required" class="form-control <#if secondFactorRequired>middle<#else>bottom</#if>"
                       placeholder="${ec.l10n.localize("Password")}" aria-label="${ec.l10n.localize("Password")}">
            </#if>
            <button class="btn btn-lg btn-primary btn-block" type="submit">${ec.l10n.localize("Sign in")}</button>
            <#if expiredCredentials><p class="text-warning text-center">WARNING: Your password has expired</p></#if>
            <#if passwordChangeRequired><p class="text-warning text-center">WARNING: Password change required</p></#if>
        </form>
    </div>
    <#if authFlowList?has_content && !authFlowList.isEmpty()>
        <div id="sso" class="tab-pane">
            <#list authFlowList as authFlow>
                <form method="post" action="/sso/login" class="form-signin">
                    <input type="hidden" name="authFlowId" value="${authFlow.authFlowId}">
                    <button class="btn btn-lg btn-primary btn-block" type="submit">${authFlow.description}</button>
                </form>
            </#list>
        </div>
    </#if>
    <div id="signup" class="tab-pane">
        <form method="post" action="${sri.buildUrl("createAccount").url}" class="form-signin" id="signup_form">
            <p class="text-muted text-center">${ec.l10n.localize("Create your account")}</p>
            <input type="hidden" name="moquiSessionToken" value="${ec.web.sessionToken}">
            <input type="hidden" name="initialTab" value="signup">
            <input id="signup_form_email" name="emailAddress" type="email" value="${(emailAddress!"")?html}"
                    required="required" class="form-control top"
                    placeholder="${ec.l10n.localize("Work Email")}" aria-label="${ec.l10n.localize("Work Email")}">
            <input id="signup_form_company" name="companyName" type="text" value="${(companyName!"")?html}"
                    required="required" class="form-control middle"
                    placeholder="${ec.l10n.localize("Company Name")}" aria-label="${ec.l10n.localize("Company Name")}">
            <input id="signup_form_firstname" name="firstName" type="text" value="${(firstName!"")?html}"
                    required="required" class="form-control middle"
                    placeholder="${ec.l10n.localize("First Name")}" aria-label="${ec.l10n.localize("First Name")}">
            <input id="signup_form_lastname" name="lastName" type="text" value="${(lastName!"")?html}"
                    required="required" class="form-control middle"
                    placeholder="${ec.l10n.localize("Last Name")}" aria-label="${ec.l10n.localize("Last Name")}">
            <input type="password" name="newPassword" required="required" class="form-control middle"
                    placeholder="${ec.l10n.localize("Password")}" aria-label="${ec.l10n.localize("Password")}">
            <input type="password" name="newPasswordVerify" required="required" class="form-control bottom"
                    placeholder="${ec.l10n.localize("Password Verify")}" aria-label="${ec.l10n.localize("Password Verify")}">
            <button class="btn btn-lg btn-success btn-block" type="submit">${ec.l10n.localize("Sign Up")}</button>
            
            <p class="text-muted text-center">Password must be at least ${minLength} characters
                with at least <strong>${minDigits} number<#if (minDigits > 1)>s</#if></strong>
                <#if (minOthers > 0)> and at least <strong>${minOthers} punctuation character<#if (minOthers > 1)>s</#if></strong></#if></p>
        </form>
    </div>
    <div id="reset" class="tab-pane">
        <form method="post" action="${sri.buildUrl("resetPassword").url}" class="form-signin" id="reset_form">
            <p class="text-muted text-center">${ec.l10n.localize("Enter your username to email a reset password")}</p>
            <input type="hidden" name="moquiSessionToken" value="${ec.web.sessionToken}">
            <input type="hidden" name="initialTab" value="reset">
            <input id="reset_form_username" name="username" type="text" value="${(username!"")?html}"
                    <#if username?has_content && secondFactorRequired>disabled="disabled"</#if>
                    required="required" class="form-control"
                    placeholder="${ec.l10n.localize("Username")}" aria-label="${ec.l10n.localize("Username")}">
            <button class="btn btn-lg btn-danger btn-block" type="submit">${ec.l10n.localize("Email Reset Password")}</button>
        </form>
    </div>
    <div id="change" class="tab-pane">
        <form method="post" action="${sri.buildUrl("changePassword").url}" class="form-signin" id="change_form">
            <p class="text-muted text-center">${ec.l10n.localize("Enter details to change your password")}</p>
            <input type="hidden" name="moquiSessionToken" value="${ec.web.sessionToken}">
            <input type="hidden" name="initialTab" value="change">
            <input id="change_form_username" name="username" type="text" value="${(username!"")?html}"
                    <#if username?has_content && secondFactorRequired>disabled="disabled"</#if>
                    required="required" class="form-control top"
                    placeholder="${ec.l10n.localize("Username")}" aria-label="${ec.l10n.localize("Username")}">
            <#-- secondFactorRequired will only be set if a user is pre-authenticated, and in that case password not required again -->
            <#if secondFactorRequired>
                <input type="hidden" name="oldPassword" value="ignored">
                <input id="change_form_code" name="code" type="text" inputmode="numeric" autocomplete="one-time-code"
                        required="required" class="form-control middle"
                        placeholder="${ec.l10n.localize("Authentication Code")}" aria-label="${ec.l10n.localize("Authentication Code")}">
            <#else>
                <input type="password" name="oldPassword" required="required" class="form-control middle"
                        placeholder="${ec.l10n.localize("Old Password")}" aria-label="${ec.l10n.localize("Old Password")}">
            </#if>
            <#-- FUTURE: fancy JS to validate PW as it is entered or on blur -->
            <input type="password" name="newPassword" required="required" class="form-control middle"
                    placeholder="${ec.l10n.localize("New Password")}" aria-label="${ec.l10n.localize("New Password")}">
            <input type="password" name="newPasswordVerify" required="required" class="form-control bottom"
                    placeholder="${ec.l10n.localize("New Password Verify")}" aria-label="${ec.l10n.localize("New Password Verify")}">
            <button class="btn btn-lg btn-danger btn-block" type="submit">${ec.l10n.localize("Change Password")}</button>

            <p class="text-muted text-center">Password must be at least ${minLength} characters
                with at least <strong>${minDigits} number<#if (minDigits > 1)>s</#if></strong>
                <#if (minOthers > 0)> and at least <strong>${minOthers} punctuation character<#if (minOthers > 1)>s</#if></strong></#if></p>
        </form>
    </div>
</div>

<#if secondFactorRequired>
    <p class="text-center">${ec.l10n.localize("An authentication code is required for your account, you have these options:")}</p>
    <ul class="form-signin" style="padding-left:40px;">
        <#list factorTypeDescriptions as factorType>
            <li>${factorType}</li>
        </#list>
    </ul>
    <#list sendableFactors as userAuthcFactor>
        <div class="text-center">
            <form method="post" action="${sri.buildUrl("sendOtp").url}" class="form-signin">
                <input type="hidden" name="factorId" value="${userAuthcFactor.factorId}">
                <input type="hidden" name="moquiSessionToken" value="${ec.web.sessionToken}">
                <input type="hidden" name="initialTab" class="initial-tab">
                <button class="btn btn-lg btn-primary" type="submit">${ec.l10n.localize("Send code to")} ${userAuthcFactor.factorOption!}</button>
            </form>
        </div>
    </#list>
</#if>

<#if (ec.web.sessionAttributes.get("moquiPreAuthcUsername"))?has_content>
    <form method="post" action="${sri.buildUrl("removePreAuth").url}" class="form-signin" id="remove_preauth_form">
        <input type="hidden" name="moquiSessionToken" value="${ec.web.sessionToken}">
        <button class="btn btn-lg btn-block" type="submit">${ec.l10n.localize("Change User")}</button>
    </form>
</#if>

<script>
$(function () {
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var $target = $(e.target);
        window.location.hash = $target.attr('href');
        var tabName = window.location.hash.slice(1);
        $('.initial-tab').val(tabName);
        $target.addClass("text-strong").removeClass("text-primary");
        if (e.relatedTarget) $(e.relatedTarget).removeClass("text-strong").addClass("text-primary");
        <#if username?has_content && secondFactorRequired>
            if (tabName === "login") { $("#login_form_code").focus(); }
            else if (tabName === "change") { $("#change_form_code").focus(); }
            else if (tabName === "reset") { $("#reset_form_username").focus(); }
            else if (tabName === "signup") { $("#signup_form_email").focus(); }
        <#else>
            if (tabName === "login") { $("#login_form_username").focus(); }
            else if (tabName === "change") { $("#change_form_username").focus(); }
            else if (tabName === "reset") { $("#reset_form_username").focus(); }
            else if (tabName === "signup") { $("#signup_form_email").focus(); }
        </#if>
    });
    $('a[href="' + (location.hash || '${initialTab!"#login"}') + '"]').tab('show');
})
</script>
