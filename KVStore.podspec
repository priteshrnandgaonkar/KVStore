Pod::Spec.new do |spec|
  spec.name = "KVStore"
  spec.version = "1.2"
  spec.summary = "Swift wrapper over sqlite CRUD"
  spec.homepage = "https://github.com/priteshrnandgaonkar/KVStore"
  spec.license = { type: 'MIT', file: 'LICENSE.md' }
  spec.authors = { "Pritesh Nandgaonkar" => 'prit.nandgaonkar@gmail.com' }
  spec.social_media_url = "https://twitter.com/prit91"
  spec.pod_target_xcconfig = {
    'SWIFT_VERSION' => '3.0',
  }
  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/priteshrnandgaonkar/KVStore.git", tag: "1.2" }
  spec.source_files = "KVStore/**/*.{h,swift}"
  spec.library = 'sqlite3'
  
end