/**
 * 인증 관련 API 함수들
 */

const API_BASE_URL = 'http://localhost:8000/api/v1';

/**
 * 회원가입
 * @param {Object} userData - 사용자 데이터
 * @param {string} userData.email - 이메일
 * @param {string} userData.username - 사용자명
 * @param {string} userData.password - 비밀번호
 * @param {string} [userData.full_name] - 전체 이름 (선택)
 * @returns {Promise<Object>} API 응답 { success, data, message }
 */
export async function register(userData) {
  const response = await fetch(`${API_BASE_URL}/auth/register`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData),
  });

  const result = await response.json();

  if (!response.ok) {
    // 에러 응답 형식: { error, message, detail }
    const errorMsg = result.detail?.message || result.message || '회원가입에 실패했습니다.';
    throw new Error(errorMsg);
  }

  // 성공 응답 형식: { success: true, data: {...}, message }
  return result;
}

/**
 * 로그인
 * @param {string} username - 사용자명
 * @param {string} password - 비밀번호
 * @returns {Promise<Object>} 액세스 토큰과 토큰 타입 { access_token, token_type }
 */
export async function login(username, password) {
  const formData = new URLSearchParams();
  formData.append('username', username);
  formData.append('password', password);

  const response = await fetch(`${API_BASE_URL}/auth/token`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: formData,
  });

  const result = await response.json();

  if (!response.ok) {
    // 에러 응답 형식: { error, message, detail }
    const errorMsg = result.detail?.message || result.message || '로그인에 실패했습니다.';
    throw new Error(errorMsg);
  }

  // 토큰 응답은 기존 OAuth2 표준 형식 유지: { access_token, token_type }
  return result;
}

/**
 * 현재 사용자 정보 가져오기
 * @param {string} token - 액세스 토큰
 * @returns {Promise<Object>} API 응답 { success, data, message }
 */
export async function getCurrentUser(token) {
  const response = await fetch(`${API_BASE_URL}/users/me`, {
    headers: {
      'Authorization': `Bearer ${token}`,
    },
  });

  const result = await response.json();

  if (!response.ok) {
    const errorMsg = result.detail?.message || result.message || '사용자 정보를 가져올 수 없습니다.';
    throw new Error(errorMsg);
  }

  // 성공 응답 형식: { success: true, data: {...}, message }
  return result;
}
