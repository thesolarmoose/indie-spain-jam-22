using System.Collections;
using System.Collections.Generic;
using TNRD;
using UnityEngine;
using Utils;
using Utils.Tweening;

namespace Audio
{
    public class TrackChanger : MonoBehaviour
    {
        [SerializeField] private float _transitionDuration;
        [SerializeField] private List<SerializableInterface<IAudioSource>> _audioSources;

        private int _currentIndexPlaying;

        private IAudioSource Current => _audioSources[_currentIndexPlaying].Value;
        
        public void ChangeTrack(int index)
        {
            var current = Current;
            _currentIndexPlaying = index;
            
            var next = _audioSources[index].Value;
            next.Volume = 0;
            next.Play();
            var transitionCoroutine = TweeningUtils.TweenTimeCoroutine(
                time =>
                {
                    current.Volume = 1 - time;
                    next.Volume = time;
                },
                _transitionDuration,
                Curves.Linear
            );
            var coroutine = CoroutineUtils.CoroutineSequence(new List<IEnumerator>
            {
                transitionCoroutine,
                CoroutineUtils.ActionCoroutine(() =>
                {
                    current.Volume = 0;
                    next.Volume = 1;
                    current.Stop();
                })
            });

            StartCoroutine(coroutine);
        }
    }
}