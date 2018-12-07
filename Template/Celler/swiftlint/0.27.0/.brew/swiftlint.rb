class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.27.0",
      :revision => "12996ef1f54002e5daa45148944ad9219dacef8a"
  head "https://github.com/realm/SwiftLint.git"

  depends_on :xcode => "8.0"
  depends_on :xcode => ["9.0", :build]

  def install
    ENV["CC"] = Utils.popen_read("xcrun -find clang").chomp # rdar://40724445

    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1: warning: Trailing Newline Violation: Files should have a single trailing newline. (trailing_newline)",
                 shell_output("SWIFTLINT_SWIFT_VERSION=3 #{bin}/swiftlint --no-cache").chomp
    assert_match version.to_s,
                 shell_output("#{bin}/swiftlint version").chomp
  end
end
