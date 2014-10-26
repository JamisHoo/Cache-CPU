
#include <stdio.h>

int p = 0;
int main() {
	int i;
	int cnt = 0;
	for (i = 0; i < 100; i ++) {
		printf("%d\n", i);
		cnt = 0;
L1:
		if ((i & 3) == 3) {
			goto L0;
		} else if ((i & 7) == 7) {
			goto L2;
L2:
			cnt += 1;
L4:
			cnt += 1;
			goto L3;
L3:
			if (cnt == 5)
				goto L5;
			goto L4;
		}
		goto L5;
L0:
		i += 3;
		goto L1;
L5:
		continue;
	}
	return i;
}
