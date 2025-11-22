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
 * @returns {Promise<Object>} 생성된 사용자 정보
 */
export async function register(userData) {
  const response = await fetch(`${API_BASE_URL}/auth/register`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.detail || '회원가입에 실패했습니다.');
  }

  return await response.json();
}

/**
 * 로그인
 * @param {string} username - 사용자명
 * @param {string} password - 비밀번호
 * @returns {Promise<Object>} 액세스 토큰과 토큰 타입
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

  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.detail || '로그인에 실패했습니다.');
  }

  return await response.json();
}

/**
 * 현재 사용자 정보 가져오기
 * @param {string} token - 액세스 토큰
 * @returns {Promise<Object>} 사용자 정보
 */
export async function getCurrentUser(token) {
  const response = await fetch(`${API_BASE_URL}/users/me`, {
    headers: {
      'Authorization': `Bearer ${token}`,
    },
  });

  if (!response.ok) {
    throw new Error('사용자 정보를 가져올 수 없습니다.');
  }

  return await response.json();
}
