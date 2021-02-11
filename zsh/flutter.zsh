if [ -d $GHQ_ROOT/github.com/flutter/flutter ]; then
    export PATH=$GHQ_ROOT/github.com/flutter/flutter/bin:$PATH
    export PATH=$GHQ_ROOT/github.com/flutter/flutter/bin/cache/dart-sdk/bin:$PATH 
else
    echo "flutter not configured."
fi

