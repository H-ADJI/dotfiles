from qutebrowser.config.config import ConfigContainer  # noqa: F401
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401

config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103
# TODO: colorsscheme
# TODO: status bar
# TODO: fonts
# TODO: ytb play
# TODO: shortcuts
# TODO: image zoom using hints and userscript to download and zoom in local img viewer
# TODO: pswd manager
# TODO: homepage
# TODO: session auto save
config.load_autoconfig()

# FONTS
font = "JetBrainsMono Nerd Font"
c.fonts.default_family = font
c.fonts.default_size = "12pt"
c.fonts.web.size.default = 17
c.fonts.web.size.default_fixed = 14
c.fonts.web.family.standard = font
c.fonts.web.family.fixed = font  # monospace
c.fonts.web.family.serif = font
c.fonts.web.family.sans_serif = font
c.fonts.web.family.cursive = font
c.fonts.web.family.fantasy = font
c.zoom.default = "110%"
c.statusbar.padding = {
    "top": 6,
    "bottom": 6,
    "left": 8,
    "right": 8,
}
c.colors.statusbar.normal.bg = "#1e1e2e"  # Catppuccin Mocha base
c.colors.statusbar.normal.fg = "#cdd6f4"
c.colors.statusbar.command.bg = "#181825"
c.colors.statusbar.command.fg = "#f38ba8"
c.colors.statusbar.url.fg = "#89b4fa"
c.colors.statusbar.progress.bg = "#f38ba8"  # page loading color

c.statusbar.widgets = [
    "text: ",  # separator
    "url",
    "text: ",  # separator
    "scroll",
    "text: ",
    "tabs",
    "progress",
]
c.colors.statusbar.passthrough.bg = "#fab387"
c.colors.statusbar.insert.bg = "#89b4fa"
c.colors.statusbar.url.error.fg = "#f38ba8"  # broken URLs
c.colors.statusbar.url.success.http.fg = "#a6e3a1"
c.colors.statusbar.url.success.https.fg = "#89b4fa"
c.colors.statusbar.url.hover.fg = "#cba6f7"
# TABS
c.tabs.favicons.scale = 1.5
c.tabs.padding = {"top": 4, "bottom": 4, "left": 4, "right": 4}
# AUTO SAVE
c.auto_save.session = True
c.auto_save.interval = 5_000
# HINTS
c.hints.border = "1px solid #1A73E8"  # bright blue border
c.colors.hints.bg = "#FFFFFF"  # white background
c.colors.hints.fg = "#000000"  # black hint letters
c.colors.hints.match.fg = "#E30000"  # blue text for matching part
c.colors.hints.bg = "#FFEB3B"  # yellow
c.colors.hints.fg = "#000000"  # black
c.hints.border = "1px solid #000000"
c.hints.radius = 4  # rounded corners
c.hints.min_chars = 1  # shorter labels
c.hints.uppercase = True
# KEYBINDS
config.bind(",au", "adblock-update")
config.bind(",s", "config-source")
config.bind(",mpv", "spawn --detach mpv {url}")
config.bind(",i", "spawn --userscript images.py")
# c.editor.command = ["nvim", "{file}"]

# Which cookies to accept. With QtWebEngine, this setting also controls
# other features with tracking capabilities similar to those of cookies;
# including IndexedDB, DOM storage, filesystem API, service workers, and
# AppCache. Note that with QtWebKit, only `all` and `never` are
# supported as per-domain values. Setting `no-3rdparty` or `no-
# unknown-3rdparty` per-domain on QtWebKit will have the same effect as
# `all`. If this setting is used with URL patterns, the pattern gets
# applied to the origin/first party URL of the page making the request,
# not the request URL. With QtWebEngine 5.15.0+, paths will be stripped
# from URLs, so URL patterns using paths will not match. With
# QtWebEngine 5.15.2+, subdomains are additionally stripped as well, so
# you will typically need to set this setting for `example.com` when the
# cookie is set on `somesubdomain.example.com` for it to work properly.
# To debug issues with this setting, start qutebrowser with `--debug
# --logfilter network --debug-flag log-cookies` which will show all
# cookies being set.
# Type: String
# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set("content.cookies.accept", "all", "chrome-devtools://*")

# Which cookies to accept. With QtWebEngine, this setting also controls
# other features with tracking capabilities similar to those of cookies;
# including IndexedDB, DOM storage, filesystem API, service workers, and
# AppCache. Note that with QtWebKit, only `all` and `never` are
# supported as per-domain values. Setting `no-3rdparty` or `no-
# unknown-3rdparty` per-domain on QtWebKit will have the same effect as
# `all`. If this setting is used with URL patterns, the pattern gets
# applied to the origin/first party URL of the page making the request,
# not the request URL. With QtWebEngine 5.15.0+, paths will be stripped
# from URLs, so URL patterns using paths will not match. With
# QtWebEngine 5.15.2+, subdomains are additionally stripped as well, so
# you will typically need to set this setting for `example.com` when the
# cookie is set on `somesubdomain.example.com` for it to work properly.
# To debug issues with this setting, start qutebrowser with `--debug
# --logfilter network --debug-flag log-cookies` which will show all
# cookies being set.
# Type: String
# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set("content.cookies.accept", "all", "devtools://*")

# Value to send in the `Accept-Language` header. Note that the value
# read from JavaScript is always the global value.
# Type: String
config.set("content.headers.accept_language", "", "https://matchmaker.krunker.io/*")

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{upstream_browser_version_short}`: The
# corresponding Safari/Chrome   version, but only with its major
# version. * `{qutebrowser_version}`: The currently running qutebrowser
# version.  The default value is equal to the default user agent of
# QtWebKit/QtWebEngine, but with the `QtWebEngine/...` part removed for
# increased compatibility.  Note that the value read from JavaScript is
# always the global value.
# Type: FormatString
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}; rv:144.0) Gecko/20100101 Firefox/144.0",
    "https://accounts.google.com/*",
)

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{upstream_browser_version_short}`: The
# corresponding Safari/Chrome   version, but only with its major
# version. * `{qutebrowser_version}`: The currently running qutebrowser
# version.  The default value is equal to the default user agent of
# QtWebKit/QtWebEngine, but with the `QtWebEngine/...` part removed for
# increased compatibility.  Note that the value read from JavaScript is
# always the global value.
# Type: FormatString
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {qt_key}/{qt_version} {upstream_browser_key}/{upstream_browser_version_short} Safari/{webkit_version}",
    "https://gitlab.gnome.org/*",
)

# Load images automatically in web pages.
# Type: Bool
config.set("content.images", True, "chrome-devtools://*")

# Load images automatically in web pages.
# Type: Bool
config.set("content.images", True, "devtools://*")

# Enable JavaScript.
# Type: Bool
config.set("content.javascript.enabled", True, "chrome-devtools://*")

# Enable JavaScript.
# Type: Bool
config.set("content.javascript.enabled", True, "devtools://*")

# Enable JavaScript.
# Type: Bool
config.set("content.javascript.enabled", True, "chrome://*/*")

# Enable JavaScript.
# Type: Bool
config.set("content.javascript.enabled", True, "qute://*/*")

# Allow locally loaded documents to access remote URLs.
# Type: Bool
config.set(
    "content.local_content_can_access_remote_urls",
    True,
    "file:///home/khalil/.local/share/qutebrowser/userscripts/*",
)

# Allow locally loaded documents to access other local URLs.
# Type: Bool
config.set(
    "content.local_content_can_access_file_urls",
    False,
    "file:///home/khalil/.local/share/qutebrowser/userscripts/*",
)

# Shrink the completion to be smaller than the configured size if there
# are no scrollbars.
# Type: Bool
c.completion.shrink = True

# Position of the tab bar.
# Type: Position
# Valid values:
#   - top
#   - bottom
#   - left
#   - right
# c.tabs.position = "top"
