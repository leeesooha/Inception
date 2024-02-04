#!/bin/bash

rm -rf /var/www/html/wordpress/wp-config-sample.php

# <mariadb 헬스체크 스크립트>
#  MariaDB 컨테이너 호스트 이름 또는 IP 주소
mariadb_host="mariadb"
# MariaDB 컨테이너의 포트 (기본적으로 3306)
mariadb_port="3306"
# MariaDB에 대한 테스트 쿼리
test_query="SELECT 1;"
# MariaDB 컨테이너가 준비될 때까지 대기
until mysql -h "$mariadb_host" -P "$mariadb_port" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "$test_query"; do
  >&2 echo "MariaDB is unavailable - sleeping"
  sleep 1
done
>&2 echo "MariaDB is up - executing command"


# <wordpress 유저 추가>
cd /var/www/html/wordpress
wp core install --allow-root --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL
wp user create $WP_USER $WP_USER_EMAIL --allow-root
wp user update $WP_USER --user_pass=$WP_USER_PASSWORD --allow-root
cd -


# <워드프레스 로그인화면 리다이렉트>
# functions.php에 추가할 php코드
code_to_add=$(cat <<EOF
function redirect_to_login_or_home() {
    if ( ! is_user_logged_in() ) {
        wp_redirect( home_url( '/wp-login.php' ) );
        exit;
    }
}
add_action( 'template_redirect', 'redirect_to_login_or_home' );
EOF
)
# 워드프레스 functions.php 파일 경로
functions_php_file="/var/www/html/wordpress/wp-includes/functions.php"
# 로그인 리다이렉션 함수가 존재하는지 먼저 확인하고
if grep -q "function redirect_to_login_or_home()" "$functions_php_file"; then
    echo "The function already exists in $functions_php_file."
else
    # functions.php 파일에 코드 추가
    if [ -f "$functions_php_file" ]; then
        echo "Adding code to $functions_php_file..."
        echo "$code_to_add" >> "$functions_php_file"
        echo "Code added successfully."
    else
        echo "Error: $functions_php_file not found."
    fi
fi

# # functions.php 파일에 코드 추가
# if [ -f "$functions_php_file" ]; then
#     echo "Adding code to $functions_php_file..."
#     echo "$code_to_add" >> "$functions_php_file"
#     echo "Code added successfully."
# else
#     echo "Error: $functions_php_file not found."
# fi


# <php-fpm 실행>
exec "$@"
# /usr/sbin/php-fpm7.4 -F