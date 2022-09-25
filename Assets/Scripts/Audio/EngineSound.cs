using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using Movement.Controllers;
using NaughtyAttributes;
using UnityEngine;
using Utils;
using Utils.Tweening;

namespace Audio
{
    public class EngineSound : MonoBehaviour
    {
        [SerializeField] private AudioClip _start;
        [SerializeField] private AudioClip _still;
        [SerializeField] private AudioClip _end;

        [SerializeField] private List<AudioSource> _sources;

        [SerializeField] private InputController _inputController;

        [SerializeField] private float _transitionDuration;
        [SerializeField] private float _waitToPercent;

        private bool _lastFrameWasRunning;
        private int _currentIndexPlaying;

        private AudioSource Current => _sources[_currentIndexPlaying];
        private AudioSource Next
        {
            get
            {
                _currentIndexPlaying = ++_currentIndexPlaying % _sources.Count;
                return _sources[_currentIndexPlaying];
            }
        }

        private void Start()
        {
            _currentIndexPlaying = 0;
        }

        private void Update()
        {
            bool startedRunning = !_lastFrameWasRunning && _inputController.IsRunning;
            if (startedRunning)
            {
                PlayEngineSound();
            }

            _lastFrameWasRunning = _inputController.IsRunning;
        }

        private async void PlayEngineSound()
        {
            StartCoroutine(ChangeClip(_start, false));

            await WaitForAudioToPercent(Current, _waitToPercent);

            while (_inputController.IsRunning)
            {
                StartCoroutine(ChangeClip(_still, false));

                await WaitForAudioToPercent(Current, _waitToPercent);
            }
            
            StartCoroutine(ChangeClip(_end, false));
        }


        private IEnumerator ChangeClip(AudioClip clip, bool loop)
        {
            var current = Current;
            var next = Next;
            next.clip = clip;
            next.loop = loop;
            next.Play();
            
            var transitionCoroutine = TweeningUtils.TweenTimeCoroutine(
                time =>
                {
                    current.volume = 1 - time;
                    next.volume = time;
                },
                _transitionDuration,
                Curves.Linear
            );
            var coroutine = CoroutineUtils.CoroutineSequence(new List<IEnumerator>
            {
                transitionCoroutine,
                CoroutineUtils.ActionCoroutine(() =>
                {
                    current.volume = 0;
                    next.volume = 1;
                })
            });

            return coroutine;
        }

        private async Task WaitForAudioToPercent(AudioSource source, float targetPercent)
        {
            var samples = source.clip.samples;
            var currentPercent = (float) source.timeSamples / samples;
            while (currentPercent < targetPercent && _inputController.IsRunning)
            {
                currentPercent = (float) source.timeSamples / samples;
                await Task.Yield();
            }
        }
    }
}