<script lang="ts">
	import { Icon, Button } from 'm3-svelte';
	import iconError from '@ktibow/iconset-material-symbols/error';

	export let message: string;
	export let onReload: () => void;
</script>

<div class="reload-widget">
	<Icon icon={iconError}></Icon>

	<p>遇到问题：{message}</p>
	<Button onclick={onReload} variant="elevated">重新加载</Button>
</div>
