package Main.Game;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

public class GameAct {
	
		//밤 행동 메서드
		static void Kill(int a, int b, Game gameData) {
			int[] pick = gameData.getPick();
			int kill = gameData.getKill();
			pick[a] = b;
			if(kill==-1) {
				kill = b;
			}else{
				int rand = (int) (Math.random()*2); //마피아 3인 이상은 다수결
				if(rand==0) {
					kill = b;
				}
			};
			gameData.setPick(pick);
			gameData.setKill(kill);
		}
		static void Live(int a, int b, Game gameData) {
			int[] pick = gameData.getPick();
			int live = gameData.getLive();
			pick[a] = b;
			live = b;
			gameData.setPick(pick);
			gameData.setLive(live);
		}
		static void Find(int a, int b, Game gameData) {
			int[] Job = gameData.getJob();
			int[] pick = gameData.getPick();
			boolean[] find = gameData.getFind();
			pick[a] = b;
			if(Job[b]==-1) {
				find[b] = true;
			}
			gameData.setJob(Job);
			gameData.setPick(pick);
			gameData.setFind(find);
		}
		
		//a->b 공론화
		static void Suspect(int a, int b, Game gameData) {
			int[] suspect_num = gameData.getSuspect_num();
			int[] Job_claim = gameData.getJob_claim();
			Map<Integer, List<Integer>> Enemy = gameData.getEnemy();
			Enemy.get(b).add(a);
			suspect_num[b]++;
			//경찰은 공론화+1
			if(Job_claim[a]==1) {
				Enemy.get(b).add(a);
				suspect_num[b]++;
			}
			gameData.setSuspect_num(suspect_num);
			gameData.setJob_claim(Job_claim);
			gameData.setEnemy(Enemy);
		}	
		
		//게임에서 추방
		static void Kick(int i, Game gameData) {
			Map<Integer, List<Integer>> Alive = gameData.getAlive();
			Map<Integer, List<Integer>> Enemy = gameData.getEnemy();
			//생존자 명단에서 제거
			if(Alive.get(-1).contains(i)) {
				for (int j = 0; j < Alive.get(-1).size(); j++) {
					if(Alive.get(-1).get(j)==i) {
						Alive.get(-1).remove(j--);
					}
				}
			}else if(Alive.get(1).contains(i)) {
				for (int j = 0; j < Alive.get(1).size(); j++) {
					if(Alive.get(1).get(j)==i) {
						Alive.get(1).remove(j--);
					}
				}
			}
			//적대 목록에서 제거
			for (int j = 0; j < Enemy.size(); j++) {
				for (int k = 0; k < Enemy.get(j).size(); k++) {
					if(Enemy.get(j).get(k)==i) {
						Enemy.get(j).remove(k--);
					}
				}
			}
			Enemy.put(i, new ArrayList<>());
			gameData.setAlive(Alive);
			gameData.setEnemy(Enemy);
		}
		
		
		
		//본인 외 랜덤 인물
		static int RandomWho(List<Integer> list, int i) {
			int who;
			do {
				int rand = (int) (Math.random()*list.size());
				who = list.get(rand);
			} while (who==i);
			return who;
		}
		//현재 생존자 전체 목록
		static List<Integer> AliveAll(Game gameData){
			List<Integer> list = new ArrayList<>();
			list.addAll(gameData.getAlive().get(1));
			list.addAll(gameData.getAlive().get(-1));
			return list;
		}
		//가장 큰 번호 찾기
		static List<Integer> FindMaxNum(int[] list) {
			int max = 0;
			List<Integer> MaxNum = new ArrayList<>();
			for (int i = 0; i < list.length; i++) {
				if(list[i]>max) {
					max = list[i];
					MaxNum = new ArrayList<>();
				}
				if(list[i]==max) {
					MaxNum.add(i);
				}
			}
			MaxNum.sort(Comparator.reverseOrder());
			return MaxNum;
		}
}
