using BrunoMikoski.AnimationSequencer;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace DefaultNamespace
{
    public class VisionController : MonoBehaviour
    {
        [SerializeField] private AnimationSequencerController _animationsController;
        [SerializeField] private FloatVariable _diameterVariable;

        public void SetVisionDiameter(float diameter)
        {
            _diameterVariable.Value = diameter;
        }

        public void AnimateVision()
        {
            _animationsController.Play();
        }
    }
}