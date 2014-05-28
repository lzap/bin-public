# sefindif - Find interface definitions that have a string that matches the
# given regular expression
sefindif() {
  REGEXP="$1";
  if test -d /usr/share/selinux/devel/include; then
    pushd /usr/share/selinux/devel/include > /dev/null 2>&1;
  else
    pushd ${POLICY_LOCATION}/policy/modules > /dev/null 2>&1;
  fi
  for FILE in */*.if;
  do
    awk "/(interface\(|template\()/ { NAME=\$NF; P=0 }; /${REGEXP}/ { if (P==0) {P=1; print NAME}; print };" ${FILE} | sed -e "s:^:${FILE}\: :g";
  done
  popd > /dev/null 2>&1;
}

# seshowif - Show the interface definition
seshowif() {
  INTERFACE="$1";
  if test -d /usr/share/selinux/devel/include; then
    pushd /usr/share/selinux/devel/include > /dev/null 2>&1;
  else
    pushd ${POLICY_LOCATION}/policy/modules > /dev/null 2>&1;
  fi
  for FILE in */*.if;
  do
    grep -A 9999 "\(interface(\`${INTERFACE}'\|template(\`${INTERFACE}'\)" ${FILE} | grep -B 9999 -m 1 "^')";
  done
  popd > /dev/null 2>&1;
}

# sefinddef - Find macro definitions that have a string that matches the given
# regular expression
sefinddef() {
  REGEXP="$1";
  if test -d /usr/share/selinux/devel/include; then
    pushd /usr/share/selinux/devel/include > /dev/null 2>&1;
  else
    pushd ${POLICY_LOCATION}/policy/modules > /dev/null 2>&1;
  fi
  for FILE in *;
  do
    awk "BEGIN { P=1; } /(define\(\`[^\`]*\`$)/ { NAME=\$NF; P=0 }; /${REGEXP}/ { if (P==0) {P=1; print NAME}; print };" ${FILE};
  done
  popd > /dev/null 2>&1;
}

# seshowdef - Show the macro definition
seshowdef() {
  MACRONAME="$1";
  if test -d /usr/share/selinux/devel/include; then
    pushd /usr/share/selinux/devel/include > /dev/null 2>&1;
  else
    pushd ${POLICY_LOCATION}/policy/modules > /dev/null 2>&1;
  fi
  for FILE in *.spt;
  do
    grep -A 9999 "define(\`${MACRONAME}'" ${FILE} | grep -B 999 -m 1 "')";
  done
  popd > /dev/null 2>&1;
}
