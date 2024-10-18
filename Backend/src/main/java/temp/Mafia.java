package temp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class Mafia {
	//기본 변수
	static int N = 8;
	static int player = -1;
	static int[] personal = new int[N]; //명예로움, 순수함, 이기적인, 사악한 - 1,0,-1,-2
	static int[] Job = {-1,-1,0,0,0,0,1,2}; //마피아, 시민, 경찰 의사 - -1,0,1,2
	static int[] Job_claim = {99,99,99,99,99,99,99,99}; //본인 주장 직업(초기 99)
	//인게임 변수
	static Map<Integer, List<Integer>> Alive = new HashMap<>(); //시민팀, 마피아팀 - 1,-1
	static Map<Integer, List<Integer>> Enemy = new HashMap<>(); //적대 인물 리스트(주관적)
	static int[] pick = new int[N]; //직업으로 선택한 사람(거짓 포함)
	static int[] pick_fake = new int[N]; //마피아의 가짜 선택
	static int[] suspect_num = new int[N]; //공론화된 숫자
	static int[] vote = new int[N];
	//시스템 변수
	static int kill; //마피아가 죽일 타겟
	static int live; //의사가 살릴 타겟
	static boolean[] find = new boolean[N]; //경찰이 보유중인 조사 리스트
	static boolean[] find_fake = new boolean[N]; //경찰행세 마피아의 가짜 결과
	
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		
		//게임 인원 참여
		player = (int) (Math.random()*N);
		for (int i = 0; i < N; i++) {
			personal[i] = (int) (Math.random()*4)-2;
			int job = Job[i];
			int shuffle = (int) (Math.random()*Job.length);
			if(shuffle>i) {
				Job[i] = Job[shuffle];
				Job[shuffle] = job;
			}
			if (Job[i] == -1) {
			    Alive.putIfAbsent(-1, new ArrayList<>());
			    Alive.get(-1).add(i);
			} else {
			    Alive.putIfAbsent(1, new ArrayList<>());
			    Alive.get(1).add(i);
			}
			Enemy.putIfAbsent(i, new ArrayList<>());
		}
		if(player!=-1) {
			System.out.println("당신"+player+"은 "+Job[player]+"입니다");
			if(Job[player]==-1) {
				System.out.println(Alive.get(-1));
			}
		}
		
		//게임 진행
		while (Alive.get(-1).size() > 0 && Alive.get(-1).size() < Alive.get(1).size()) {
			//밤
			System.out.println("밤이 되었습니다..");
			kill = -1; //죽일 타겟 초기화
			live = -1; //살릴 대상 초기화
			for (int i = 0; i < N; i++) {
				if(Alive.get(1).contains(i) || Alive.get(-1).contains(i)) {
					if(i==player) {
						int who = -1;
						switch (Job[player]) {
						case -1:
							System.out.println("누구를 죽입니까?");
							who = sc.nextInt();
							Kill(player, who);
							break;
						case 1:
							System.out.println("누구를 조사합니까?");
							who = sc.nextInt();
							Find(player, who);
							break;
						case 2:
							System.out.println("누구를 살립니까?");
							who = sc.nextInt();
							Live(player, who);
							break;
						}
					}else {
						AI_Night(i);
					}
				}
			}
			//살인 유효성 검사
			if(kill!=live && kill!=-1) {
				System.out.println(kill+"이 죽었습니다.");
				Kick(kill);
			}else {
				System.out.println("아무도 죽지 않았습니다.");
			}
			//디버그용
//			System.out.println(Alive);
//			System.out.println(Arrays.toString(Job));
//			System.out.println(Arrays.toString(personal));
//			System.out.println(Enemy);
//			System.out.println(Arrays.toString(suspect_num));
//			System.out.println(FindMaxNum(suspect_num));
			
			//낮
			System.out.println("낮이 되었습니다!");
			suspect_num = new int[N]; //공론화 초기화
			for (int i = 0; i < N; i++) {
				if(Alive.get(1).contains(i) || Alive.get(-1).contains(i)) {
					if(i==player) {
						System.out.println("1.의견내기 2.직업공개 3.가만있기");
						int action = sc.nextInt();
						if(action==1) {
							System.out.println("누구를 공론화합니까?");
							int who = sc.nextInt();
							Suspect(player, who);
						}else if(action==2) {
							if(Alive.get(-1).contains(player)) {
								if(Job_claim[player]==99) {
									System.out.println("거짓말할 직업 번호를 작성하세요");
									Job_claim[player] = sc.nextInt();	
								}
								if(Job_claim[player]>=1) {
									System.out.println("누구를 대상으로 직업활동을 했는지 거짓 번호를 적으세요");
									pick_fake[player] = sc.nextInt();
									if(Job_claim[player]==1) {
										System.out.println("조사결과를 어떻게 거짓말 하시겠습니까?(0:시민,1:마피아)");
										int result_fake = sc.nextInt();
										if(result_fake==0) {
											find_fake[pick_fake[player]]=true;
										}
									}
								}
							}
							OpenJob(player);
						}else if(action==3) {
							Nothing(player);
						}	
					}else {
						AI_Day(i);
					}
				}	
			}
			//투표
			System.out.println("투표를 시작합니다.");
			vote = new int[N]; //투표 초기화
			for (int i = 0; i < N; i++) {
				if(Alive.get(1).contains(i) || Alive.get(-1).contains(i)) {
					if(i==player) {
						System.out.println("누구를 투표합니까?");
						int who = sc.nextInt();
						Vote(player, who);
					}else {
						AI_Vote(i);
					}
				}	
			}
			//투표 유효성 검사(동률은 세이브)
			List<Integer> prisoner = new ArrayList<>();
			prisoner = FindMaxNum(vote);
			if(prisoner.size()!=1) {
				System.out.println("최다득표가 나오지 않아, 투표가 무산됩니다.");
			}else {
				System.out.println(prisoner.get(0)+"이 투표로 처형되었습니다.");
				Kick(prisoner.get(0));
			}
			
		}
		
		//결과
		if(Alive.get(-1).size() == 0) {
			System.out.println("시민 승!");
		}else {
			System.out.println("마피아 승!");
		}
		System.out.println(Arrays.toString(Job));
		
		sc.close();
	}
	
	//밤 행동 메서드
	static void Kill(int a, int b) {
		pick[a] = b;
		if(kill==-1) {
			kill = b;
		}else{
			int rand = (int) (Math.random()*2); //마피아 3인 이상은 다수결
			if(rand==0) {
				kill = b;
			}
		};
	}
	static void Live(int a, int b) {
		pick[a] = b;
		live = b;
	}
	static void Find(int a, int b) {
		pick[a] = b;
		if(Job[b]==-1) {
			find[b] = true;
			if(a==player) {
				System.out.println("마피아가 맞습니다!");
			}
		}else {
			if(a==player) {
				System.out.println("마피아가 아닙니다..");
			}
		}
	}
	
	//a->b 공론화
	static void Suspect(int a, int b) {
		Enemy.get(b).add(a);
		suspect_num[b]++;
		//경찰은 공론화+1
		if(Job_claim[a]==1) {
			Enemy.get(b).add(a);
			suspect_num[b]++;
		}
		System.out.println(a+": 저는 "+b+"를 의심합니다");
	}
	//직업공개 후 누굴 지목했는지 밝힘
	static void OpenJob(int i) {
		if(Job_claim[i]==99) {
			Job_claim[i]=Job[i];
		}
		switch(Job[i]){
			case -1:
				switch(Job_claim[i]){
				case 0:
					System.out.println(i+": 저는 시민이에요");
					break;
				case 1:
					System.out.println(i+": 저는 경찰이고, 조사결과 "+pick[i]+"는 "+find_fake[pick_fake[i]]+"입니다.");
					//조사결과 마피아라고 구라치면 공론화, 그 외 상대호의 획득
					if(find_fake[pick_fake[i]]) {
						Suspect(i, pick_fake[i]);
					}else {
						if(Enemy.get(pick_fake[pick_fake[i]]).contains(pick_fake[i])) {
							for (int j = 0; j < Enemy.get(pick_fake[pick_fake[i]]).size(); j++) {
								if(Enemy.get(pick_fake[pick_fake[i]]).get(j)==pick_fake[i]) {
									Enemy.get(pick_fake[pick_fake[i]]).remove(j);
								}
							}
						}
					}
					break;
				case 2:
					System.out.println(i+": 저는 의사고, 살린 사람은 "+pick_fake[i]+"입니다.");
					break;
				}
				break;
			case 0:
				System.out.println(i+": 저는 시민이에요");
				break;
			case 1:
				System.out.println(i+": 저는 경찰이고, 조사결과 "+pick[i]+"는 "+find[pick[i]]+"입니다.");
				if(Job[pick[i]]==-1) {
					//조사결과 마피아일 때는 공론화
					Suspect(i, pick[i]);
				}else {
					//조사결과 시민일 때는 상호 적대리스트 삭제
					if(Enemy.get(i).contains(pick[i])) {
						for (int j = 0; j < Enemy.get(i).size(); j++) {
							if(Enemy.get(i).get(j)==pick[i]) {
								Enemy.get(i).remove(j);
							}
						}
					}
					if(Enemy.get(pick[i]).contains(i)) {
						for (int j = 0; j < Enemy.get(pick[i]).size(); j++) {
							if(Enemy.get(pick[i]).get(j)==i) {
								Enemy.get(pick[i]).remove(j);
							}
						}
					}
				}
				break;
			case 2:
				System.out.println(i+": 저는 의사고, 살린 사람은 "+pick[i]+"입니다.");
				break;
		}
		//동일직업은 "의견내기" 추가 자동시행
		for (int j = 0; j < Job_claim.length; j++) {
			if(Job_claim[i]==Job_claim[j] && i!=j && Job_claim[i]!=0 && AliveAll().contains(j)) {
				if(Job_claim[i]==1) {
					System.out.println(i+": 제가 진짜 경찰인데, "+j+"가 거짓말하네요?");
				}else if(Job_claim[i]==2){
					System.out.println(i+": 제가 진짜 의사인데, "+j+"가 거짓말하네요?");
				}
				Suspect(i, j);
			}
		}
		
	}
	static void Nothing(int i) {
		suspect_num[i]++;
		System.out.println(i+": 누구지..");
	}
	
	//a->b 투표
	static void Vote(int a, int b) {
		vote[b]++;
		System.out.println(a+"가 "+b+"에게 투표 하였습니다.");
	}
	//게임에서 추방
	static void Kick(int i) {
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
	}
	
	static void AI_Night(int i) { 
		List<Integer> list = new ArrayList<>();
		if(Alive.get(1).contains(i)) {
			switch (personal[i]) {
			case 1:	
				switch(Job[i]) {
					case 1:
						//특수 직업 검증하거나 랜덤 조사
						list = new ArrayList<>();
						for (int j = 0; j < Job_claim.length; j++) {
							if((Job_claim[j]==1 || Job_claim[j]==2) && (Alive.get(1).contains(j) || Alive.get(-1).contains(j)) && i!=j) {
								list.add(j);
							}
						}
						if(!list.isEmpty()) {
							Find(i, RandomWho(list, i));
						}else {
							Find(i, RandomWho(AliveAll(), i));
						}
						break;
					case 2:
						//특수 직업 치료하거나 랜덤 치료
						list = new ArrayList<>();
						for (int j = 0; j < Job_claim.length; j++) {
							if((Job_claim[j]==1 || Job_claim[j]==2) && (Alive.get(1).contains(j) || Alive.get(-1).contains(j)) && i!=j) {
								list.add(j);
							}
						}
						if(!list.isEmpty()) {
							Live(i, RandomWho(list, i));
						}else {
							Live(i, RandomWho(AliveAll(), i));
						}
						break;
				}
				break;
			case 0:
				switch(Job[i]) {
					case 1:
						Find(i, RandomWho(AliveAll(), i));
						break;
					case 2:
						Live(i, RandomWho(AliveAll(), i));
						break;
				}
				break;
			case -1:
				switch(Job[i]) {
					case 1:
						//특수 직업 조사나, 적대인물 조사나, 랜덤 조사
						list = new ArrayList<>();
						for (int j = 0; j < Job_claim.length; j++) {
							if((Job_claim[j]==1 || Job_claim[j]==2) && (Alive.get(1).contains(j) || Alive.get(-1).contains(j)) && i!=j) {
								list.add(j);
							}
						}
						if(!list.isEmpty()) {
							Find(i, RandomWho(list, i));
						}else if(!Enemy.get(i).isEmpty()){
							Find(i, RandomWho(Enemy.get(i), i));
						}else {
							Find(i, RandomWho(AliveAll(), i));
						}
						break;
					case 2:
						Live(i,i);
						break;
				}
				break;
			case -2:
				switch(Job[i]) {
					case 1:
						//적대인물 조사나, 랜덤 조사
						if(!Enemy.get(i).isEmpty()){
							Find(i, RandomWho(Enemy.get(i), i));
						}else {
							Find(i, RandomWho(AliveAll(), i));
						}
						break;
					case 2:
						Live(i,i);
						break;
				}
				break;
			}
		}else if(Alive.get(-1).contains(i)) {
			switch (personal[i]) {
			case 1:
				//경찰 살인이나 랜덤 살인
				list = new ArrayList<>();
				for (int j = 0; j < Job_claim.length; j++) {
					if(Job_claim[j]==1 && Alive.get(1).contains(j) && i!=j) {
						list.add(j);
					}
				}
				if(!list.isEmpty()) {
					Kill(i, RandomWho(list, i));
				}else {
					Kill(i, RandomWho(Alive.get(1), i));
				}
				break;
			case 0:
				Kill(i, RandomWho(Alive.get(1), i));
				break;
			case -1:
				//경찰 살인이나, 적대인물 살인이나, 랜덤 살인
				list = new ArrayList<>();
				for (int j = 0; j < Job_claim.length; j++) {
					if(Job_claim[j]==1 && Alive.get(1).contains(j) && i!=j) {
						list.add(j);
					}
				}
				if(!list.isEmpty()) {
					Kill(i, RandomWho(list, i));
				}else if(!Enemy.get(i).isEmpty()){
					Kill(i, RandomWho(Enemy.get(i), i));
				}else {
					Kill(i, RandomWho(Alive.get(1), i));
				}
				break;
			case -2:
				//적대인물 살인이나, 랜덤 살인
				if(!Enemy.get(i).isEmpty()){
					Kill(i, RandomWho(Enemy.get(i), i));
				}else {
					Kill(i, RandomWho(Alive.get(1), i));
				}
				break;
			}
		}
	}
	
	static void AI_Day(int i) {
		int who;
		if(Alive.get(1).contains(i)) {
			//(명예로운, 순수한)경찰이면 무조건 직업공개
			if(Job[i]==1 && (personal[i]==1 || personal[i]==0)) {
				OpenJob(i);
				return;
			}
			//그 외
			switch (personal[i]) {
			case 1:
				OpenJob(i);
				break;
			case 0:
				Nothing(i);
				break;
			case -1:
				//적대인물 공격 - 직업 공개
				if(!Enemy.get(i).isEmpty()) {
					Suspect(i, RandomWho(Enemy.get(i), i));
				}else {
					OpenJob(i);
				}
				break;
			case -2:
				if(!Enemy.get(i).isEmpty()) {
					//적대인물 의견내기
					Suspect(i, RandomWho(Enemy.get(i), i));
				}else {
					//아무나 의견내기
					Suspect(i, RandomWho(AliveAll(), i));
				}
				break;
			}
		}else if(Alive.get(-1).contains(i)) {
			//마피아 일때,
			switch (personal[i]) {
			case 1:
				//경찰, 의사 주장자 있으면 공론화
				List<Integer> target = new ArrayList<>();
				for (int j = 0; j < Job_claim.length; j++) {
					if((Job_claim[j]==1 || Job_claim[j]==2) && Alive.get(1).contains(j)) {
						target.add(j);
					}
				}
				if(!target.isEmpty()) {
					who = (int) (Math.random()*target.size());
					Suspect(i, who);
				}else {
					//가짜 직업 공개
					FakeJob(i);
					OpenJob(i);
				}
				break;
			case 0:
				Nothing(i);
				break;
			case -1:
				//가짜 직업 공개
				FakeJob(i);
				OpenJob(i);
				break;
			case -2:
				//적대인물 또는 랜덤 의견내기
				if(!Enemy.get(i).isEmpty()) {
					Suspect(i, RandomWho(Enemy.get(i), i));
				}else {
					Suspect(i, RandomWho(Alive.get(1), i));
				}
				break;
			}
		}
	}
	
	static void AI_Vote(int i) {
		List<Integer> list = new ArrayList<>();
		int[] temp;
		if(Alive.get(1).contains(i)) {
			//경찰이면 무조건 true 투표
			if(Job[i]==1) {
				for (int j = 0; j < find.length; j++) {
					if(find[j] && Alive.get(-1).contains(j)) {
						Vote(i, j);
						return;
					}
				}
			}
			//그 외
			switch (personal[i]) {
			case 1:
				//최다공론화(본인제외)
				temp = suspect_num.clone();
				temp[i]=0;
				Vote(i, FindMaxNum(temp).get(0));
				break;
			case 0:
				//최다공론화(본인제외)
				temp = suspect_num.clone();
				temp[i]=0;
				Vote(i, FindMaxNum(temp).get(0));
				break;
			case -1:
				if(!Enemy.get(i).isEmpty()) {
					Vote(i, RandomWho(Enemy.get(i), i));
				}else {
					//최다공론화(본인제외)
					temp = suspect_num.clone();
					temp[i]=0;
					Vote(i, FindMaxNum(temp).get(0));
				}
				break;
			case -2:
				if(!Enemy.get(i).isEmpty()) {
					Vote(i, RandomWho(Enemy.get(i), i));
				}else {
					Vote(i, RandomWho(AliveAll(), i));
				}
				break;
			}
		}else if(Alive.get(-1).contains(i)) {
			switch (personal[i]) {
			case 1:
				//특수 직업 - 적대인물 - 랜덤 순으로 투표
				list = new ArrayList<>();
				for (int j = 0; j < Job_claim.length; j++) {
					if((Job_claim[j]==1 || Job_claim[j]==2) && Alive.get(1).contains(j)) {
						list.add(j);
					}
				}
				if(!list.isEmpty()) {
					Vote(i, RandomWho(list, i));
				}else {
					Vote(i, RandomWho(Alive.get(1), i));
				}
				break;
			case 0:
				//최다공론화(본인제외)
				temp = suspect_num.clone();
				temp[i]=0;
				Vote(i, FindMaxNum(temp).get(0));
				break;
			case -1:
				//특수 직업 - 적대인물 - 랜덤 순으로 투표
				list = new ArrayList<>();
				for (int j = 0; j < Job_claim.length; j++) {
					if((Job_claim[j]==1 || Job_claim[j]==2) && Alive.get(1).contains(j)) {
						list.add(j);
					}
				}
				if(!list.isEmpty()) {
					Vote(i, RandomWho(list, i));
				}else if(!Enemy.get(i).isEmpty()){
					Vote(i, RandomWho(Enemy.get(i), i));
				}else {
					Vote(i, RandomWho(Alive.get(1), i));
				}
				break;
			case -2:
				if(!Enemy.get(i).isEmpty()) {
					Vote(i, RandomWho(Enemy.get(i), i));
				}else {
					Vote(i, RandomWho(Alive.get(1), i));
				}
				break;
			}
		}
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
	static List<Integer> AliveAll(){
		List<Integer> list = new ArrayList<>();
		list.addAll(Alive.get(1));
		list.addAll(Alive.get(-1));
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
	//가짜 직업활동
	static void FakeJob(int i) {
		//가짜 직업 공개
		if(Job_claim[i]==99) {
			Job_claim[i] =  (int) (Math.random()*3);
		}
		if(Job_claim[i]==1) {
			if((int) (Math.random()*2) == 0) {
				pick_fake[i] = RandomWho(Alive.get(1), i);
				find_fake[pick_fake[i]] = true;
			}else {
				pick_fake[i] = RandomWho(Alive.get(-1), i);
				find_fake[pick_fake[i]] = false;
			}
		}else if(Job_claim[i]==2) {
			pick_fake[i] = RandomWho(AliveAll(), i);
		}
	}

	
}
