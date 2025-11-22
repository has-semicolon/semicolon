import { writable } from 'svelte/store';
import { browser } from '$app/environment';

/**
 * 인증 스토어
 * - token: JWT 액세스 토큰
 * - user: 현재 로그인한 사용자 정보
 */
function createAuthStore() {
  // 로컬 스토리지에서 초기값 로드 (브라우저 환경에서만)
  const storedToken = browser ? localStorage.getItem('token') : null;
  const storedUser = browser ? localStorage.getItem('user') : null;

  const { subscribe, set, update } = writable({
    token: storedToken,
    user: storedUser ? JSON.parse(storedUser) : null,
  });

  return {
    subscribe,
    /**
     * 로그인 - 토큰과 사용자 정보 저장
     * @param {string} token - JWT 토큰
     * @param {Object} user - 사용자 정보
     */
    login: (token, user) => {
      if (browser) {
        localStorage.setItem('token', token);
        localStorage.setItem('user', JSON.stringify(user));
      }
      set({ token, user });
    },
    /**
     * 로그아웃 - 토큰과 사용자 정보 제거
     */
    logout: () => {
      if (browser) {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
      }
      set({ token: null, user: null });
    },
    /**
     * 사용자 정보 업데이트
     * @param {Object} user - 업데이트된 사용자 정보
     */
    updateUser: (user) => {
      if (browser) {
        localStorage.setItem('user', JSON.stringify(user));
      }
      update(state => ({ ...state, user }));
    },
  };
}

export const authStore = createAuthStore();
