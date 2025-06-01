```bash
#!/bin/bash

read user pass

if [ "$user" == $USERNAME ] && [ "$pass" == $PASS ]; then
  echo "OK"
else
  echo "ERROR"
fi
```