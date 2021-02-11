def is_m1?
    !RUBY_PLATFORM.index("arm64e").nil?
end

def brew_skip_m1(name, **args)
    if is_m1?
        puts "Skip brew #{name}"
        return
    end

    brew name, args
end

def cask_skip_m1(name, **args)
    if is_m1?
        puts "Skip cask #{name}"
        return
    end

    cask name, args
end
